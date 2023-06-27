//
//  Generic Merge Sort.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-27.
//

import Foundation

/**
 Performs merge on two sorted arrays, returning the result.
 
 The arrays must be sorted such that compare(a[0], a[1]) returns true
 
 The result will be sorted using the provided compare such that, if compare(x, y) returns true, x will appear before y in the output.
 */
func merge<T>(a: [T], b: [T], compare: (T, T) -> Bool) -> [T] {
    var ret: [T] = .init()
    
    var aIdx = 0
    var bIdx = 0
    
    // merge
    while aIdx < a.count && bIdx < b.count {
        if compare(a[aIdx], b[bIdx]) {
            ret.append(a[aIdx])
            aIdx += 1
        } else {
            ret.append(b[bIdx])
            bIdx += 1
        }
    }
    
    // handle remaining values
    while aIdx < a.count {
        ret.append(a[aIdx])
        aIdx += 1
    }
    while bIdx < b.count {
        ret.append(b[bIdx])
        bIdx += 1
    }
    
    return ret
}
