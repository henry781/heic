# heic

## Usage

```
heic [--quality <quality>] <source> <destination>
```

```
ARGUMENTS:
  <source>                Source file or directory
  <destination>           Destination file or directory

OPTIONS:
  -q, --quality <quality> Quality between 1 and 100 (lossless)
```

## Examples

### Convert a single image to heic

```
heic ../IMG_2063.png ../IMG_2063.heic
```

* **destination** should end with `.heic` or `.HEIC`

### Convert images in a directory to heic

```
heic ../images ../images_heic
```

* **destination** should be a directory
* this tool creates the same structure in the **destination** directory


## Story

I have a library with thousands of large pictures (50mb to 100mb) in tiff, png...
This tool allows to create a portable copy of my library using heic.

## Contributing

This is one of my first code in swift, it can certainly be improved.

Build
```
swift build
```

Build release
```
swift build -c release 
```
