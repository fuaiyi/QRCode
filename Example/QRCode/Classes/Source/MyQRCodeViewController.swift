//
//  MyQRCodeViewController.swift
//  QRCode
//
//  Created by gaofu on 16/9/9.
//  Copyright © 2016年 gaofu. All rights reserved.
//

import UIKit

class MyQRCodeViewController: UIViewController
{
    
    //MARK: -
    //MARK: Global Variables
    
    @IBOutlet private weak var myQRCode: UIImageView!
    
    //MARK: -
    //MARK: Lazy Components
    
    
    //MARK: -
    //MARK: Public Methods
    
    
    //MARK: -
    //MARK: Data Initialize
    
    
    //MARK: -
    //MARK: Life Cycle
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        myQRCode.image = "https://github.com/fuaiyi/QRCode.git".generateQRCodeWithLogo(logo: UIImage(named: "8_150709170804_8"))
        
    }
    
    
    //MARK: -
    //MARK: Interface Components
    
    
    //MARK: -
    //MARK: Target Action
    
    
    //MARK: -
    //MARK: Data Request
    
    
    //MARK: -
    //MARK: Private Methods
    
    
    //MARK: -
    //MARK: Dealloc
    
    
}


//MARK: -
//MARK: <#statement#> Delegate



