import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

guard CommandLine.arguments.count == 3 else {
    fputs("Usage: swift generate-icon.swift SOURCE.png OUTPUT.icns\n", stderr)
    exit(EXIT_FAILURE)
}

let fileManager = FileManager.default
let sourceURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
let iconsetURL = outputURL
    .deletingLastPathComponent()
    .appendingPathComponent("YTMusicApp.iconset", isDirectory: true)

guard let imageSource = CGImageSourceCreateWithURL(sourceURL as CFURL, nil),
      let sourceImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
    fputs("Could not read icon source at \(sourceURL.path)\n", stderr)
    exit(EXIT_FAILURE)
}

try? fileManager.removeItem(at: iconsetURL)
try fileManager.createDirectory(
    at: iconsetURL,
    withIntermediateDirectories: true
)

func renderIcon(pixels: Int, filename: String) throws {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(
        data: nil,
        width: pixels,
        height: pixels,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
        throw CocoaError(.featureUnsupported)
    }

    let size = CGFloat(pixels)
    let inset = size * 0.035
    let tileRect = CGRect(
        x: inset,
        y: inset,
        width: size - inset * 2,
        height: size - inset * 2
    )
    let tileMask = CGPath(
        roundedRect: tileRect,
        cornerWidth: size * 0.19,
        cornerHeight: size * 0.19,
        transform: nil
    )

    context.addPath(tileMask)
    context.clip()
    context.interpolationQuality = .high
    context.draw(sourceImage, in: CGRect(x: 0, y: 0, width: size, height: size))

    guard let renderedImage = context.makeImage() else {
        throw CocoaError(.fileWriteUnknown)
    }

    let destinationURL = iconsetURL.appendingPathComponent(filename)
    guard let destination = CGImageDestinationCreateWithURL(
        destinationURL as CFURL,
        UTType.png.identifier as CFString,
        1,
        nil
    ) else {
        throw CocoaError(.fileWriteUnknown)
    }
    CGImageDestinationAddImage(destination, renderedImage, nil)
    guard CGImageDestinationFinalize(destination) else {
        throw CocoaError(.fileWriteUnknown)
    }
}

let iconFiles: [(Int, String)] = [
    (16, "icon_16x16.png"),
    (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"),
    (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"),
    (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"),
    (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"),
    (1024, "icon_512x512@2x.png")
]

for (pixels, filename) in iconFiles {
    try renderIcon(pixels: pixels, filename: filename)
}

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
process.arguments = [
    "--convert", "icns",
    "--output", outputURL.path,
    iconsetURL.path
]
try process.run()
process.waitUntilExit()

guard process.terminationStatus == 0 else {
    fputs("iconutil failed with status \(process.terminationStatus)\n", stderr)
    exit(process.terminationStatus)
}

try fileManager.removeItem(at: iconsetURL)
print("Generated \(outputURL.path) from \(sourceURL.path)")
