//
//  UIImage+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/20.
//

import UIKit

extension UIImage {
    
    /// Helper function to center-crop image.
    ///
    /// - Returns: Center-cropped copy of this image
    func cropCenter() -> UIImage? {
        let isPortrait = size.height > size.width
        let isLandscape = size.width > size.height
        let breadth = min(size.width, size.height)
        let breadthSize = CGSize(width: breadth, height: breadth)
        let breadthRect = CGRect(origin: .zero, size: breadthSize)
        
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        let croppingOrigin = CGPoint(
            x: isLandscape ? floor((size.width - size.height) / 2) : 0,
            y: isPortrait ? floor((size.height - size.width) / 2) : 0
        )
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: croppingOrigin, size: breadthSize))
        else { return nil }
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    /// Create an `UIImage` from the given pixel array.
    ///
    /// - Parameters
    ///   - pixels: The pixel array to create an image from.
    ///   - size: The target image's size.
    ///
    /// - Returns: The `UIImage` object or `nil` if the image could not be drawn.
    static func fromSRGBColorArray(pixels: [UInt32], size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {
            print("ERROR: The target image size must be positive.")
            return nil
        }
        
        // Fails if the size of the target doesn't match with the total pixels in the SRGB array.
        guard pixels.count == Int(size.width * size.height) else {
            print(
                "ERROR: The size of the target image (\(size)) doesn't match with the total number of ",
                "pixels (\(pixels.count)) in the SRGB array."
            )
            return nil
        }
        
        // Make a mutable copy.
        var data = pixels
        
        // Convert array of pixels to a `CGImage` instance.
        let cgImage = data.withUnsafeMutableBytes { (ptr) -> CGImage in
            let ctx = CGContext(
                data: ptr.baseAddress,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: 8,
                bytesPerRow: MemoryLayout<UInt32>.size * Int(size.width),
                space: CGColorSpace(name: CGColorSpace.sRGB)!,
                bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue
                + CGImageAlphaInfo.premultipliedFirst.rawValue
            )!
            return ctx.makeImage()!
        }
        
        // Convert the `CGImage` instance to an `UIImage` instance.
        return UIImage(cgImage: cgImage)
    }
    
    /// Resize the image to the given size.
    func resize(targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    /// Compare the image to another image, returning true if they are similar.
    func isSimilar(to other: UIImage, tolerance: CGFloat) -> Bool {
        guard let data = self.pngData(), let otherData = other.pngData() else {
            return false
        }
        
        // Make sure both images have the same size
        guard self.size == other.size else {
            return false
        }
        
        let difference = data.enumerated().reduce(0) { accumulator, tuple in
            // Safely get otherByte avoiding index out of range
            guard let otherByte = otherData[safe: tuple.offset] else {
                return accumulator
            }
            
            let byte = tuple.element
            return accumulator + abs(Int(byte) - Int(otherByte))
        }
        
        let differencePercent = CGFloat(difference) / CGFloat(data.count)
        return differencePercent < tolerance
    }
    /// Resize the image to the given size while maintaining the aspect ratio.
    func resize(to targetSize: CGSize) -> UIImage {
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        } else {
            newSize = CGSize(width: self.size.width * widthRatio,  height: self.size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
