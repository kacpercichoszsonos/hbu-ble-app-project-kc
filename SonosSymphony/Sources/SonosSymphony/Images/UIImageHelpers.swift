//
//  UIImageHelpers.swift
//
//
//  Created by Tri Pham on 1/27/23.
//

import CoreImage
import Foundation
import SwiftUI
import UIKit

private extension CGFloat {
    static let fullRevolution: CGFloat = 360.0
    static let maxColorValue: CGFloat = 255
}

private extension CIColor {
    static func seeds(of quantity: Int) -> [CIColor] {
        let step: CGFloat = .fullRevolution / CGFloat(quantity)
        return stride(from: CGFloat.zero, to: .fullRevolution, by: step).map { hue in
            let uiColor = UIColor(hue: hue / 360, saturation: 0.5, brightness: 0.5, alpha: 1)
            return CIColor(color: uiColor)
        }
    }
}

private enum ColorValueIndex: Int {
    case redIndex = 0
    case greenIndex = 1
    case blueIndex = 2
    case alphaIndex = 3
}

private extension Int {
    static let bytesPerColor: Int = 4

    // Color's values Indices
    static let redIndex = 0
    static let greenIndex = 1
    static let blueIndex = 2
    static let alphaIndex = 3
}

private extension String {
    static let clusterCountKey = "inputCount"
    static let kMeanPassesKey = "inputPasses"
    static let inputPerceptualKey = "inputPerceptual"
    static let centroidSeedsKey = "inputMeans"
}

private extension CIContext {
    static let shared = CIContext()
}

public extension UIImage {
    static let context = CIContext()

    private func kMeanFilter(for image: CIImage,
                             numClusters: Int,
                             numPasses: Int) -> CIFilter? {
        let params: [String: Any] = [
            kCIInputImageKey: image,
            kCIInputExtentKey: CIVector(cgRect: image.extent),
            .clusterCountKey: numClusters,
            .inputPerceptualKey: NSNumber(value: true),
            .kMeanPassesKey: numPasses,
            .centroidSeedsKey: CIColor.seeds(of: numClusters)
        ]
        return CIFilter(name: "CIKMeans", parameters: params)
    }

    private func colorPalettes(from bitmap: [UInt8], with numClusters: Int) -> [UIColor] {
        (0 ..< numClusters).map { clusterIndex in
            UIColor(
                red: CGFloat(bitmap[clusterIndex * .bytesPerColor + .redIndex]) / .maxColorValue,
                green: CGFloat(bitmap[clusterIndex * .bytesPerColor + .greenIndex]) / .maxColorValue,
                blue: CGFloat(bitmap[clusterIndex * .bytesPerColor + .blueIndex]) / .maxColorValue,
                alpha: CGFloat(bitmap[clusterIndex * .bytesPerColor + .alphaIndex]) / .maxColorValue
            )
        }
    }

    public func kMeansClustering(numClusters: Int, numPasses: Int) async -> [UIColor] {
        guard let image = preparingThumbnail(of: CGSize(width: 100, height: 100)),
              let ciImage = CIImage(image: image),
              let kMeansFilter = kMeanFilter(for: ciImage, numClusters: numClusters, numPasses: numPasses)
        else {
            return []
        }

        guard var outputImage = kMeansFilter.outputImage else {
            return []
        }
        outputImage = outputImage.settingAlphaOne(in: outputImage.extent)

        var bitmap = [UInt8](repeating: 0, count: .bytesPerColor * numClusters)
        CIContext.shared.render(outputImage,
                                toBitmap: &bitmap,
                                rowBytes: .bytesPerColor * numClusters,
                                bounds: outputImage.extent,
                                format: .RGBA8,
                                colorSpace: ciImage.colorSpace!)

        return colorPalettes(from: bitmap, with: numClusters)
    }

    // MARK: Average color
    private func areaAverageFilter(ciImage inputImage: CIImage) -> CIFilter? {
        if let filter = CIFilter(name: "CIAreaAverage",
                            parameters: [kCIInputImageKey: inputImage,
                                        kCIInputExtentKey: CIVector(cgRect: inputImage.extent)]) {
            return filter
        } else {
            return nil
        }
    }
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self),
              let filter = areaAverageFilter(ciImage: inputImage) else {
            return nil
        }

        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: .bytesPerColor)
        CIContext.shared.render(outputImage,
                       toBitmap: &bitmap,
                                rowBytes: .bytesPerColor,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8, colorSpace: inputImage.colorSpace!)

        return UIColor(red: CGFloat(bitmap[.redIndex]) / .maxColorValue,
                       green: CGFloat(bitmap[.greenIndex]) / .maxColorValue,
                       blue: CGFloat(bitmap[.blueIndex]) / .maxColorValue,
                       alpha: CGFloat(bitmap[.alphaIndex]) / .maxColorValue)
    }
}
