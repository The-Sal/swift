/*
I mean this is all just modifications to the standard library, right?
So what have I learned?:
- You can modify the standard library to add custom functionality.
- The `@inlinable` makes it so the functions are basically everywhere in the codebase, kinda... like hidden code before main of defnitions or something.
– For some reason without @inlineable the compiler doesnt compile, moreover if we call print within the stdlib then segfault in the compiling process? (how the fuck is that possible?)
– The GroupInfo.json, CMAKEList.txt are the two places were you need to add swift files for mods to work
– Either im breaking something or not but I dont get why we even have groups when I can arbitrarily throw things inside like `Mods` group oh well
– Why have CMAKE and GroupInfo? why not.. just the one... or better yet since you have this nice prestigious JSON just make Python make the CMAake on the fly isnt that easier? idk
– wtf does `@safe` mean? so idk why prolly for good reason but none of the stdlib swift file implement classes when i searched with rg "class" -g *.swift except like the one class
@safe
public class AnyKeyPath: _AppendKeyPath {
  /// The root type for this key path.
  @inlinable
  public static var rootType: Any.Type {
    return _rootAndValueType.root
  }
^^ wtf even is this @safe where did they yoink that outta? that code snippet btw is from stdlib/core/public/KeyPath.swift (yes offical as it gets)

which used @safe idk why? maybe to tell the compiler that these classes are safe to use???? idk??? also why do we need the class to be public AND THE INIT to be public is it not implied?
– Also reminder for later on the ./fast-build.sh has hard coded paths that lead to symlinks that hop to NVMe rmbr to fix that at some point and make it `portable`
– Oh wait i just compiled without @safe and it just worked??? so idk what the deal is with that @safe method best no to use things i dont understand
– also why does functions in classes sometimes use @inlinable whats the meaning of that how can you take the func out of the class if its in the class scope and just call it like min()
when its in the class scope??? idk idk idk

–  no seriously WHAT IS @SAFE EXPLAIN SOMEONE IVE NEVER SEEN IT IN MY LIFE OF WRITING SWIFT CODE AM I SHIT DEV???

– okay now heres the goal im basic`lly like a crippled child right now I cant use anything swifty at all like theres no print, or actually theres nothing beside like `>` or if statments which is fun
so I need to find where I can actually do some magic where can I write code with other swift code?

– MY GOD I HAVE A SOLUTION TO THIS SO THIS CODE WE ARE WRITING IS SWIFT CODE RIGHT WHICH MEANS THIS GETS `COMPILED` AT SOME POINT AKA BEFORE THIS GETS
TOUCHED CPP CODE MUST'VE BEEN COMPILED FIRST... WHICH MEANS I CAN WRITE SOME STUPID CRAZY C++ CODE AND THEN COMPILE IT AND THEN CALL IT FROM HERE BY SOMEHOW CONNECTING THIS
FILE WITH CPP AND THEN I CAN INJECT WHATEVER MAGIC INTO MY CUSTOM TYPES wait a second... what if OH I HAVE AN IDEA SO i want to make a function called playAudio() which is
going to be defined here like `playAudio(String)` right and its going to call a CPP function playAudioCPP and thats going to call a dylib I wrote in classical swift that uses AVFoundation to play audio
and then exported that function using @_cdecl, I mean i already made this dylib for something else but now I can use it here do some SWIFT-CEPTION do you think the compiler will be upset im calling random
dylibs from the stdlib through C++ code??? hmmmmm idk

– wait to what end can I do this? lowkey I could go build an entire fucking world in cpp then just link it to swift stdlib and expose it here... WAIT A SECOND IS THAT HOW THIS IS DONE TOO WOAH I JUST CLOCKED THAT
unless its not because they probably make primitives like if's and but statements and then that turns into Swift but still just a thought.

– now small issue with everything I said writing C++ is like the equivilant of mandarin to me... so yk what they say no better way to learn manderin than to just fuck it and do it, i should probablt figure wtf those .h files
mean I mean what even is a fucking header its so dumb like CPP i can write some little scripts here and there dont get me wrong by little i mean if-statements little but like then theres like headers and cmakes and linking
cpp with swift i mean what even in the black magic is that


– OKAY I FOUND SOMETHING CRAZY SO READING AROUND SWIFT AND C++ BECANE BFFS RECENTLY AND I CAN JUST MAGICALLY CALL FORM .H FILES AS LONG AS I TELL THE COMPILER SOME NICE THINGS AND CREATE A `MODULE MAP` RIGHT NOT SURE WHAT THAT IS
BUT ITS SOMETHING THAT ESSENTIALLY SHOWS SWIFT HEADER FILES AND ITS LIKE CONTRACTS (OR THATS MY CONCEPTUALISATION) OF THE FILE NOW THATS NOT IMPORTANT SO I WAS WONDERING IF THIS IS EVEN POSSIBLE MAYBE THE MAGIC TO MAKE SWIFT CALL
C++ ALSO REQUIRES ME TO FUCKIMG BUILD THE STUPID STDLIB BUT LOOK WHAT I FOUND IN stdlib/core/public/Cxx/libstdxx

//===--- libstdcxx.modulemap ----------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
//  In order to use a C++ stdlib from Swift, the stdlib needs to have a Clang
//  module map. Currently libstdc++ does not have a module map. To work around
//  this, Swift provides its own module map for libstdc++.
//
//===----------------------------------------------------------------------===//

A FUCKING MODULE MAP THESE BASTARDS MADE A MODULE MAP FOR CPP STDLIB THEIR CHEATING TOO WTF SO I CAN JUST MAKE A MODULE MAP FOR MY CPP CODE AND CALL IT FROM SWIFT like what even is swift now huh????? C++ wrapped in fancy
syntax????? ARE WE AT ANOTHER CPython SITUATION HERE??? I mean i know we are not because I know compilers at a high level right AST -> black magic -> LLVM -> machine code but this is crazy that means FileManager is what just a wrapper
for C++ code somwhere deep down if its using swift stdlib which is using C++ stdlib which is using C++ code right????

– I FOUND SOMETHING AMAING while LOOKING FOR MODULE MAPS WITHIN THIS CODEBASE LOOK ATHIS LINE FROM THE NUMERICS.CPP FILE IN THE STDLIB

```
using namespace swift;

/// Convert an integer literal to the floating-point type T.
template <class T>
static T convert(IntegerLiteral value) {
  using SignedChunk = IntegerLiteral::SignedChunk;
  using UnsignedChunk = IntegerLiteral::UnsignedChunk;

  auto data = value.getData();
```

DO YOU SEE THAT THEY ARE USING `AUTO` KEYWORD WHICH IS WHAT I DO ALL THE TIME BC I HATE DEFINING TYPES SO THIS MEANS ME AND SWIFT ARE ON THE SAME WAVELENGTH

– now not to sound crazy but.... lowkey looking around and after poking about i dont feel lowkey indimidated at all like it seems digestable like I can understand at some level
whats going on. THAT BEING SAID WHATEVER IS HAPPENING IN lib/ with AST ASTGen ASTDigestor Driver DriverTool IRGen etc.. that shit is some demonic stuff idek yet but looking at the
cpp code from the stdlib which is large but also not crazy like idk cpp that well but like idk programers patern matching as to whats going on ykwim like i get the jist- of it that being said its still this big
Language                 Files     Lines   Blanks  Comments     Code Complexity
───────────────────────────────────────────────────────────────────────────────
Swift                      400    171348    16197     60382    94769      11110
C++                        105     58566     8181      8867    41518       6288
C Header                    92     74059     3046      4218    66795        714
CMake                       34      4148      495       374     3279        199
Objective C++               11      4112      594       778     2740        399
Module-Definition            5      1146      172         0      974         52
Assembly                     3       530       51         2      477         12
C                            2       170       15        74       81          8
JSON                         2       293        0         0      293          0
Plain Text                   2        11        3         0        8          0
Markdown                     1        10        3         0        7          0
Objective C                  1        73        9        33       31          1
───────────────────────────────────────────────────────────────────────────────
Total                      658    314466    28766     74728   210972      18783
───────────────────────────────────────────────────────────────────────────────

so yea big but like my brain is wrapping around it not too badly

– also learned about @inlineable apparently on class functions if you dont include it the compiler forgets what Swift boolians are? idek what that means but yea it literally went Swift.Bool ?? and I was like me too bro
I think once i get that playAudio integration sorted which involved modifying the Cmake file for the swift runtime that is the predecssor for the stdlib I can probably start poking around and breaking interesting things
because that would make me:
* write real C++
* Understand wtf C++ and Headers are and how they connect to swift with .modulemap files
* re-write the build system for the swift runtime to include my cpp code
* somehow not break the other dependencies that rely on the swift runtime being standard
* idk im feeling confident about this whole thikng now despite still not knowing what @safe means and why we have to FUCKING IMPORT STRINGS IN C++ FILES LIKE #include <string> DIDNT KNOW WE WERE IN MEDIVAL TIMES

Also wtf is this build system its literally the call tree CLion -> baash -> bash -> cmake -> ninja -> Python -> swift-frontend ???

– Day2:
– first thing is that day 2 isnt going to do a lot of anything because im sleepy but I did decide there no such this as 'too much' complexity so I opened
pandoras box that is lib/AST/ and started reading through some of the cpp and I must say.... not that bad..... although I've only read a few files so far
and I dont get all the CPP magic but not the worse thing ever like for example I read lib/AST/TypeWalker.cpp and I was like I get this
lowkey like understood what its doing its purpose and made a note to rmbr this file anytime we implement our own custom types later down the line but yea
not too shabby plus with a little help from GPT-OSS20B of all things got it pretty well. Also I have learned a few things about this traverser
firstly its so like funny the patterns it has it has a callback for pre-walk and post-walk which you can customise with an override and thats so funny
to me its like idk so normal but interestingly this means all this checking can be uh 'linieant' for my custom type implementaetions cuz like.... I can just
tell it maybe dont look too deeply at this type trust in the programmer. also doesnt break the other types bc its specific for this type ykwim? And also I think I know
how I'd do multi inheritence now with swift I THINK. Here me out:
* Every type is just a C++ type right? Like Ints are deepdown cpp like to the compiler there a 'Cpp–Int' somewhere that it checks against right
* If I made a type called MagicInheritor right and its constructor took an array of pointers of whatever the CPP representation of 'classes' are
* then whenver Swift code calls a function in the 'classes abstract cpp definition' we can just have a conditional thats like if this is a MagicInheritor subclass
* call a function of the CPP MagicInheritor with the name of the function  and it will return a pointer to the correct function in the correct class
like imagine


// imagine this was C++ instead of swift-like for the sake of argument
class MagicInheritor {
  init(parents: [CppClassPointers]) { ... }
  func requestPointer(attributeName: String) -> CppPointer {}
}

and within swift you would do something like
class MyClass: MagicInheritor {
  init() {
    super.init(parents: [ThisSwiftClass(), AnotherSwiftClass(), ...]) // () -> for pointers
    self.callFunctionOfAnotherSwift()
  }
}

and under the good you would have
callFunctionOfAnotherSwift() -> Abstract CPP class (part of swift) -> if MagicInheritor -> requestPointer("callFunctionOfAnotherSwift") -> get pointer to AnotherSwiftClass.callFunctionOfAnotherSwift() -> execute
And boom cuz here's the thing everything the compiler does is high-key opt-in like swift isn't magically safe god-fearing code thats just what the devs for the IntCpp-Version and what not
I can just tell the compiler 'hey this MagicInheritor is special trust me dont look too deep' and then boom problem solved. Now does this technically mean that possibly every single MagicInheritor
class if you make a type in the method call the compiler wont catch it and you will run into a segfault at runtime.... the asnwer is... yes. BUT like dont be stupid. Also at some point ill figure out
how to fix that problem and make the compiler really 'check' these things but for now this would work and make multi-inheritence possible in swift which is cool as fuck. ALSO diamond problem
easy solution just dont deal with it... each sub-class is containerised as it's own little thing that you can talk to so memory wise you have

––––––––––––––––––-CLASS A––––––––––––––––––––––
Methods:
Functions:
Attrs:
BaseClasses: [Protocol 1, OneRealClass]

––––––––––––––––––-CLASS B––––––––––––––––––––––
Methods:
Functions:
Attrs:
BaseClasses: [Protocol 2, OneRealClass] (these are pointers btw)

––––––––––––––––––-CLASS C – with Multi––––––––––––––––––––––
Methods:
Functions:
Attrs:
BaseClasses[MultiPtr]

––––––––––– MultiPtr ––––––––––––––
array = [
class_a_OneRealClass_ptr
class_b_OneRealClass_ptr
]

Now can it cross contaminate?  idts because once we handoff to class_a_OneRealClass_ptr every thing that you wrote
after that is to that pointer outside our scope wait unless class_a_OneRealClass_ptr modifies a type which you override......
actually no fuck you no over-riding types. And theoretically since they could have the same functions both classes then
one will always be called first and yk what to solve this problem when MagicInheritor does init it will build a map
of all the functions and if theres overlap fatalError() cuz whyre u being like this yk what real composition is bringing
things that are seperate together not merging just stop being a weirdo.  Then ofc theres the meta issue
of MagicInheritor(MagicInheritored–Class) which btw thats imo just throwing a compiler error liek when it does the visit
thing its going to check if the MagicInheritor is being init-ed by another MagicInheritor and this is pretty easy since
MagicInheritor erases the underlying type since from Swift-POV its just once class MagicInheritor and internally
has pointer blackmagic so if we check with a cast or smthn if the init type is MagicInheritor and just fatalError saying
fuck you that should be dandy WAIT I JUST SOLVED IT I HAD AN AMAZING IDEA OF HOW TO DO MAGIC INHREITOR ON MAGIC INHERITOR CLASSSES
AND A BUNCH OF OTHER THINGS OKAY:

TLDR: if you init MagicInheritor with another MagicInheritor it will copy over the internal pointers from the child (the one being passed in)
and append them to its own array of pointers this way you can have MagicInheritor of MagicInheritor of MagicInheritor and then
because we are responsible devs just deallocate the child inheritor class pointer from memoery so its kinda like eating its child.
Now overriding I think I have a solution for that too basically when the swift compiler see the overide
keyowrd right it checks if the subclass (usually the one like NSObject) has that function right which means its
another from compiler pov walking up the inheritence usually just by 1 right and so we just habe the MagicInheritor
when it gets probed for override it just returns true, and then during rumtime if you lied and said override
and no sub-classes have it then boom fatalError but you can now override. And what we're going to do when you do
override MagicInheritor will take that function and store it and then go down to the 'original' class pointer
and replace the 'real' pointer to your function something like this

class MyClass {
public:
    virtual void x() { /* original implementation */ }
};

// Your replacement function
void b(MyClass* thisPtr) { /* new implementation */ }

// Access and modify vtable
MyClass* pointerClass = new MyClass();
void*** vtable = reinterpret_cast<void***>(pointerClass);
vtable[0][0] = reinterpret_cast<void*>(&b); // Modify first virtual function

and then we keep an internal pointer to the original function within MagicInheritor so if you want to call super.x() it just calls that pointer. BOOM PROBLEM SOLVED MULTI-INHERITENCE IN SWIFT. To summarise
MagicInheritor will support:
Arbitrary number of subclasses
Overriding functions, methods, attributes
Calling super.method() from overridden methods
You can do MagicInheritor of MagicInheritor

No diamond problem because idw, Like on a serious note CPP is running underneath all that Swift like looking
at the stdlib its Cpp being called underneath so like inside cpp we can do all the magic runtime stuff and all whatever
we want and then just expose enough to swift and then lie enough to the compiler to make it a functional MACH–O file once
we are in runtime whats stopping our cpp class from dowing whatever we want really? like playAudio() stdlib func thats
a real stdlib function I added whats stopping that from idk starting threads making network request by tunnelling through cpp?
 */

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
