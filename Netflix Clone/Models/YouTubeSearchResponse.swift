//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Жавохир Низомов on 06/09/22.
//

import Foundation

struct YouTubeSearchResponse : Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}


/*
 etag = 5qtqe8RhHCw31OlnNCy5gSz1XXc;
 items =     (
             {
         etag = "TSOK8snSs_iBojI702ayP0mOsD0";
         id =             {
             kind = "youtube#video";
             videoId = H34I537VNtQ;
         };
         kind = "youtube#searchResult";
     },
 */
