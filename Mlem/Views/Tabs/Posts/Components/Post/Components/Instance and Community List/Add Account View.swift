//
//  Add Saved Instance View.swift
//  Mlem
//
//  Created by David Bureš on 05.05.2023.
//

import SwiftUI
import SwiftyJSON

struct AddSavedInstanceView: View
{
    @EnvironmentObject var communityTracker: SavedAccountTracker
    @EnvironmentObject var appState: AppState

    @Binding var isShowingSheet: Bool

    @State private var instanceLink: String = ""
    @State private var usernameOrEmail: String = ""
    @State private var password: String = ""

    @State private var token: String = ""

    @State private var isShowingEndpointDiscoverySpinner: Bool = false
    @State private var hasSuccessfulyConnectedToEndpoint: Bool = false
    @State private var errorOccuredWhileConnectingToEndpoint: Bool = false
    @State private var errorText: String = ""

    @FocusState var isFocused

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack(alignment: .center){
                    HStack{
                        if let icon = UIApplication.shared.icon {
                            Image(uiImage: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                                .padding(5)
                        }
                    }
                }
                VStack {
                    Text("Account Details")
                }

                Form {
                    Section("Homepage") {
                        TextField("Homepage:", text: $instanceLink, prompt: Text("lemmy.ml"))
                            .autocorrectionDisabled()
                            .focused($isFocused)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                            .onAppear {
                                isFocused = true
                            }
                    }

                    Section("Credentials") {
                        TextField("Username", text: $usernameOrEmail, prompt: Text("Username"))
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                            .textInputAutocapitalization(.never)
                        
                        SecureField("Password", text: $password, prompt: Text("Password"))
                            .submitLabel(.go)
                    }
                    
                    Section {
                        Button(action: {
                            Task {
                                await tryToAddAccount()
                            }
                        }) {
                            Text("Log In")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    (instanceLink.isEmpty || usernameOrEmail.isEmpty || password.isEmpty)
                                    ? Color.gray
                                    : Color.blue
                                )
                                .cornerRadius(10)
                        }
                        .disabled(instanceLink.isEmpty || usernameOrEmail.isEmpty || password.isEmpty)
                    }
                }
                .disabled(isShowingEndpointDiscoverySpinner)
                .onSubmit {
                    Task {
                        await tryToAddAccount()
                    }
                }
            }
            
            if isShowingEndpointDiscoverySpinner {
                VStack(alignment: .center) {
                    Spacer()

                    VStack(alignment: .center, spacing: 10) {
                        if !errorOccuredWhileConnectingToEndpoint {
                            if !hasSuccessfulyConnectedToEndpoint {
                                ProgressView()
                                Text("Connecting")
                                    .multilineTextAlignment(.center)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 50))
                                Text("Success!")
                            }
                        } else {
                            Image(systemName: "xmark.square.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 50))
                            Text(errorText)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 10, x: 0, y: 0)

                    Spacer()
                }
            }
        }
    }


    func tryToAddAccount() async
    {
        print("Will start the account addition process")

        withAnimation
        {
            isShowingEndpointDiscoverySpinner = true
        }

        do
        {
            let sanitizedLink: String = instanceLink.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "www.", with: "")
            
            print("Sanitized link: \(sanitizedLink)")
            
            let instanceURL = try await getCorrectURLtoEndpoint(baseInstanceAddress: sanitizedLink)
            print("Found correct endpoint: \(instanceURL)")

            if instanceURL.absoluteString.contains("v1")
            { /// If the link is to a v1 instance, stop and show an error
                
                withAnimation {
                    isShowingEndpointDiscoverySpinner.toggle()
                }
                
                appState.alertTitle = "Unsupported Lemmy Version"
                appState.alertMessage = "\(instanceLink) uses an outdated version of Lemmy that Mlem doesn't support.\nContanct \(instanceLink) developers for more information."
                appState.isShowingAlert.toggle()
                                
                return
            }
            else
            {
                do
                {
                    let loginRequestResponse = try await sendPostCommand(appState: appState, baseURL: instanceURL, endpoint: "user/login", arguments: ["username_or_email": "\(usernameOrEmail)", "password": "\(password)"])
                    if loginRequestResponse.contains("jwt")
                    {
                        hasSuccessfulyConnectedToEndpoint = true
                        
                        print("Successfully got the token")
                        
                        let parsedResponse: JSON = try! parseJSON(from: loginRequestResponse)
                        
                        token = parsedResponse["jwt"].stringValue
                        
                        print("Obtained token: \(token)")
                        
                        let newAccount = SavedAccount(id: try await getUserID(instanceURL: instanceURL), instanceLink: instanceURL, accessToken: token, username: usernameOrEmail)
                        
                        print("New account: \(newAccount)")
                        
                        // MARK: - Save the account's credentials into the keychain
                        AppConstants.keychain["\(newAccount.id)_accessToken"] = token
                        
                        communityTracker.savedAccounts.append(newAccount)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                        {
                            isShowingSheet = false
                        }
                    }
                    else
                    {
                        print("Error occured: \(loginRequestResponse)")
                        
                        errorText = "Invalid credentials"
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                        {
                            errorOccuredWhileConnectingToEndpoint = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                withAnimation
                                {
                                    isShowingEndpointDiscoverySpinner = false
                                    errorOccuredWhileConnectingToEndpoint = false
                                }
                            }
                        }
                    }
                }
                catch let loginRequestError
                {
                    print("Failed while sending login command: \(loginRequestError)")
                    
                    errorText = "Could not connect to \(instanceLink)"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        errorOccuredWhileConnectingToEndpoint = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                        {
                            withAnimation
                            {
                                isShowingEndpointDiscoverySpinner = false
                                errorOccuredWhileConnectingToEndpoint = false
                            }
                        }
                    }
                }
            }
            
        }
        catch let endpointDiscoveryError
        {
            print("Failed while trying to get correct URL to endpoint: \(endpointDiscoveryError)")

            errorText = "Could not connect to \(instanceLink)"

            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
            {
                errorOccuredWhileConnectingToEndpoint = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                {
                    withAnimation
                    {
                        isShowingEndpointDiscoverySpinner = false
                        errorOccuredWhileConnectingToEndpoint = false
                    }
                }
            }
        }
    }
    
    func getUserID(instanceURL: URL) async throws -> Int
    {
        
        enum UserIDRetrievalError: Error
        {
            case couldNotFetchUserInformation, couldNotParseUserInformation
        }
        
        do
        {
            let detailsAboutAccountResponse: String = try await sendGetCommand(appState: appState, baseURL: instanceURL, endpoint: "user", parameters: [
                URLQueryItem(name: "username", value: "\(usernameOrEmail)@\(instanceURL.host!)")
            ])
            
            print("Information about this user: \(detailsAboutAccountResponse)")
                
                do
                {
                    let parsedUserDetails: JSON = try parseJSON(from: detailsAboutAccountResponse)
                    let parsedUserID: Int = parsedUserDetails["person_view", "person", "id"].intValue
                    
                    print("Parsed user ID: \(parsedUserID)")
                    
                    return parsedUserID
                }
                catch
                {
                    
                    throw UserIDRetrievalError.couldNotParseUserInformation
                }
        }
        catch
        {
            appState.alertTitle = "Couldn't fetch user information"
            appState.alertMessage = "Mlem couldn't fetch you account's information.\nFile a bug report."
            
            appState.isShowingAlert = true
            
            throw UserIDRetrievalError.couldNotFetchUserInformation
        }
    }
}

extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        
        return UIImage(named: lastIcon)
    }
}
