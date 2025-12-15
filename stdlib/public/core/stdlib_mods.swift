@_silgen_name("playAudio")
@inlinable
public func playAudio(_ filePath: UnsafePointer<CChar>)

@inlinable
public func playSound(filePath: String) {
  filePath.withCString {
    cString in
    playAudio(cString)
  }
}

@inlinable
public func turbo() -> Bool{
  return true
}

public class TurboClass {
  public init() {}
  public var speed: Int = 10

  @inlinable
  public func isTurboEnabled() -> Bool {
    return turbo()
  }
}
