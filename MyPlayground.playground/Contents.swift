//: Playground - noun: a place where people can play

import UIKit
import Accelerate

var str = "Hello, playground"



let fileManager = NSFileManager.defaultManager()

func createBlurredImages(image: UIImage, name: String) {
    let lightImage = image.applyLightEffectMod()
    let darkImage = image.applyDarkMod()
    var data = UIImagePNGRepresentation(lightImage!)
    var filePath = NSTemporaryDirectory().stringByAppendingString("\(name) - bgLightBlur.png")
    fileManager.createFileAtPath(filePath, contents: data, attributes: nil)
    data = UIImagePNGRepresentation(darkImage!)
    filePath = NSTemporaryDirectory().stringByAppendingString("\(name) - bgDarkBlur.png")
    fileManager.createFileAtPath(filePath, contents: data, attributes: nil)

}

var names = ["Animals", "Colors", "Flowers", "Fruits", "Shapes", "Solar System", "Vegetables"]
for name in names {
    let image = UIImage(named: "\(name) - bg")
//    createBlurredImages(image!, name: name)
}





