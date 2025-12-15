import Foundation

var myVariable: [Int] = []

for i in 1...20{
    myVariable.append(i)
}

print(myVariable)

print("Checking minimum of two random values:")
let valueA = myVariable.randomElement()!
let valueB = myVariable.randomElement()!

print("The first value is: \(valueA)")
print("The second value is: \(valueB)")

let minimumValue = min(valueA, valueB)

print("=========================================")
print("The minimum value is: \(minimumValue)")


let myMagicValue = turbo()
print("Turbo is set to: \(myMagicValue)")
if myMagicValue{
    print("Turbo mode is ON!")
} else {
    print("Turbo mode is OFF!")
}

let turboClass = TurboClass()
print("TurboClass is Turbo Enabled: \(turboClass.isTurboEnabled())")

playAudio("/Users/Salman/Projects/PycharmProjects/MusicGrabber/MusicGrabberDevProject/Downloads/overdrive.mp3")

for s in 1...3{
  sleep(1)
  print("Sleeping for \(s)")
}
