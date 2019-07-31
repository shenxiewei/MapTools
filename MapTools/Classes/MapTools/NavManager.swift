//
//  NavManager.swift
//  SodaMove
//
//  Created by SXW on 2019/7/30.
//  Copyright © 2019 汤世昭. All rights reserved.
//

import UIKit

//定义三方导航平台

enum NaviPlatform:CustomStringConvertible
{
    case Baidu
    case Gaode
    case Apple
    
    var description: String{
        switch self {
        case .Baidu:
            return "Baidu"
        case .Gaode:
            return "Gaode"
        case .Apple:
            return "Apple"
        }
    }
    
    public var downloadURL:String
    {
        get{
            switch self {
            case .Baidu:
                return "https://itunes.apple.com/cn/app/id452186370?ls=1&mt=8"
            case .Gaode:
                return "https://itunes.apple.com/cn/app/id461703208"
            case .Apple:
                return "https://itunes.apple.com/cn/app/maps/id915056765?mt=8"
            }
        }
    }
}

class NavManager: NSObject {
    
    static let shareIntance:NavManager = NavManager()
    
    convenience init(_ platforms:[NaviPlatform])
    {
        self.init()
    }
    
    ///高德坐标转百度
    
    func gaodeToBdw(_ lat:Double,_ lon:Double) -> CLLocationCoordinate2D{
        let x_pi:Double = 3.14159265358979324 * 3000.0 / 180.0
        let x:Double = lon - 0.0065
        let y:Double = lat - 0.006
        let z:Double = sqrt(x*x+y*y) - 0.00002 * sin(y*x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x*x_pi)
        return CLLocationCoordinate2D(lat: z*sin(theta), long: z*cos(theta))
    }
    
    ///百度坐标转高德
    
    func bdToGaode(_ lat:Double,_ lon:Double) -> CLLocationCoordinate2D{
        let x_pi:Double = 3.14159265358979324 * 3000.0 / 180.0
        let x:Double = lon
        let y:Double = lat
        let z:Double = sqrt(x*x+y*y) - 0.00002 * sin(y*x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x*x_pi)
        return CLLocationCoordinate2D(lat: z*sin(theta)+0.006, long: z*cos(theta)+0.0065)
    }
    
    ///导航到第三方，坐标高德
    
    func show3rdPartyMap(coordinate:CLLocationCoordinate2D,platforms:[NaviPlatform] =  [.Apple,.Baidu,.Gaode])
    {
        var lat = coordinate.latitude
        var lng = coordinate.longitude
        let actionSheet = UIAlertController(title: "导航", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        //添加配置的地图选项
        for type in platforms {
            actionSheet.addAction(UIAlertAction(title: type.description, style: .default, handler: {[unowned self]  _ in
                if UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com/")!) && type == .Apple
                {
                    let  urlString = "http://maps.apple.com/?daddr=\(lat),\(lng)"
                    let data = urlString.data(using: String.Encoding.utf8)
                    let url = URL(dataRepresentation: data!, relativeTo: nil)
                    UIApplication.shared.openURL(url!)
                }else if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) && type == .Gaode
                {
                    let urlString = "iosamap://path?sourceApplication=applicationName&sid=BGVIS1&did=BGVIS2&dlat=\(lat)&dlon=\(lng)&dev=0&t=0"
                    UIApplication.shared.openURL(URL(string: urlString)!)
                }else if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) && type == .Baidu
                {
                    lat = self.bdToGaode(lat, lng).latitude
                    lng = self.bdToGaode(lat, lng).longitude
                    let  urlString = "baidumap://map/direction?destination=\(lat),\(lng)&mode=driving"
                    let data = urlString.data(using: String.Encoding.utf8)
                    let url = URL(dataRepresentation: data!, relativeTo: nil)
                    UIApplication.shared.openURL(url!)
                }else
                {
                    let mapName = type.description
                    let url = type.downloadURL
                    self.alertDownloadMap(mapName, url)
                }
            }))
        }
         UIApplication.shared.keyWindow?.rootViewController!.present(actionSheet)
    }
    
    private func alertDownloadMap(_ title:String,_ url:String)
    {
        let alert = UIAlertController(title: "您未安装\(title)地图，前往下载？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "去下载", style: .default, handler: {_ in
            UIApplication.shared.openURL(URL(string: url)!)
        }))
        UIApplication.shared.keyWindow?.rootViewController!.present(alert)
    }
}
