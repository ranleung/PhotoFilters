//
//  PhotoDelegate.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/15/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

protocol PhotoDelegate: class {
    func controller(controller: UIViewController, didTapOnPicture image: UIImage?)
}