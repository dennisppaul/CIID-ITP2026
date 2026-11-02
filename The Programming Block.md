# The Programming Block

## BLOCK 00 "Preface"

- TOPIC: Modus Operandi
    - Programming Together ( i.e live coding: "this is the format we will be mostly living in for the rest of the week" )
    - let s make "A Tiny Game" before we even start to explain anything we just do a short inpromptu game
- TOPIC: The Environment
    - Download + Install Processing from https://processing.org/download
    - while we are waiting (www)
    - Processing.org: 2001, ben fry + casey reas, opensource 
        - history: Processing is derived from [John Maeda: Design by Numbers (1999)](https://maedastudio.com/1999/dbn/index.php)
    - Editor aka Integrated Development Environment (IDE), Library, Idea
    - @mental-model The Sketch
- TOPIC: The Editor
    - play/stop button
    - console window
    - tabs
    - sketch ( in file system )
    - `~/Documents/Processing`
- ASSIGNMENT: explore the environment by creating a sketch that opens a blank window. Change the size and background color.
- TOPIC: Learning More About the Environment
    - The Website: https://processing.org
    - The Reference:  https://processing.org/reference
    - The Examples: 
        - IDE ( `File > Examples…` or `⇧⌘O` )
        - website https://processing.org/examples 
        - how to deal and play with examples? @keyword(tweaking)
    - The Tutorials: https://processing.org/tutorials
    - The Videos: Videos e.g [Daniel Shiffman: The Coding Train](https://thecodingtrain.com/) on YouTube
- ASSIGNMENT: explore the environment by looking up a function in the reference ( e.g `size()`, try right-clicking it )
- ASSIGNMENT: explore the environment looking up ( e.g `size()` ) and by opening examples.
- TOPIC: LLMs as Learning + Teaching Assistance
    - make it a co-teacher
    - use a (system)prompt to get better learning experience "i am just starting with creative coding. do not fully make things for me but rather explain things to me until we both have the feeling that i understand."
- ASSIGNMENT: Ask a LLM chatbot something about a function e.g why the `size()` comes in two different flavors under syntax?

## BLOCK 01 "Variables+Functions+Shapes"

- TOPIC: A Few Conventions
    - a function always starts with a word ( usually a verb ) and has round brackets ( sometimes empty )
    - a variable also start with a word ( adjective or noun ) and can be written to ( with `=` ) or can be read from 
    - lines always end with `;` ( logic )
    - lines that start with `//` are ignored by Processing and are called *comments* ( `/* also a comment but can span multiple lines … also called block comment */` )
    - curly brackets ( `{ ... }` ) can contain multiple lines of code
    - a sketch always has a `setup()` function ( called once at the start of the sketch ) and a `draw()` function ( called at framerate until sketch stops )
    - your code lives in the curly brackets `{ ... }` … for now
    - use `println()` to write into the console
- ASSIGNMENT: look up a the following shape and *setting* functions from the reference and *understand* them by using them in a sketch:
    - `background()`
    - `ellipse()`
    - `stroke()`
    - `fill()`
- CHALLENGE: rainbow circle: make this ( a six-color ) rainbow with only three calls to the ellipse function

- TOPIC: @mental-model functions are verbs, variables are adjectives or nouns
    - functions ( or methods ) (Verbs) + Data/Variables/Constants (Adjectives+Nouns)
    - function *signature*:
        - parameters
        - return types
    - variable declare, asign (write), and read
    - constants, a special kind of *variable*
    - variable scope ( quick warning on *shadowing* )
    - coding style: 
        - naming conventions ( consistency, "code should read like a poem" )
        - formatting ( no tabs, 4 spaces, always! )
        - some examples
- ASSIGNMENT: create a function that draws a custom shape. Use variables for the size and position of the shape.

@end_of_day(00)

- TOPIC: built-in variables
    - mouse, keyboard, framerate
- ASSIGNMENT: make the `ellipse` size change dynamically based on `mouseX` and `mouseY`.

- TOPIC: built in functions
    - mouse and key events ( also *callback* functions )
    - string ops
    - random
    - map
- @todo(assignments are NOT so cool;))
- ASSIGNMENT: use `random()` to create a sketch where shapes appear in random locations every frame.
- ASSIGNMENT: create a sketch where a rectangle follows the mouse, but its speed is scaled using `map()`.
- TOPIC: commenting + debugging: how to deal with errors 
    - generally: you are learning a language
    - generally: programming is precise, small things matter!
    - errors can be cool
    - a digital *signature*, glitches
    - console
        - don't be scared of the errors
        - don't be scared of the reference
    - use `println`
        - debugging
        - BTW this *textmode* is an art form. do you know text-based User Interfaces (TUI)?
    - comments
        - notes for your future self
        - keep it short
        - your main loop should read like a poem
- ASSIGNMENT: intentionally introduce an error into your code ( e.g misspell `background` ) and describe how to fix it based on the error message.
- TOPIC: look at all these shapes
    - include `background` and `stroke/fill`
- ASSIGNMENT: draw a figurative somethings using a combination of basic shapes like rectangles, ellipses, and triangles.

- EOD-ASSIGNMENT: "Draw your Emoji!"

- RECAP: Functions + Variables
     - @note(explain with pen&paper or white-board)
     - variables: @mental-model containers in memory
     - functions: @mental-model do something  
     - RECAP: functions ( return type + parameters, how and when to use them + coding style )

- TOPIC: complex data types
    - RECAP: simple datatypes 
    - @mental-model containers of containers in computer memory 
    - `String` a special kind of complex
    - `PVector`
    - create with `new`
- ASSIGNMENT: draw shapes using only PVector for their positions
- ASSIGNMENT: create a sketch that prints your name in the console using a `String` variable.

- OPTIONAL_ASSIGNMENT: run an example and change something in it
- OPTIONAL_ASSIGNMENT: parameterization: remove all numbers from your functions
- OPTIONAL_ASSIGNMENT: make a crazy mouse pointer

## BLOCK 02 "Loops+Conditionals+Arrays"

@note(memory in computer … use mental model of cardboard boxes)

- TOPIC: conditionals + operators
- ASSIGNMENT: write a program where clicking the mouse toggles the background between two colors.
- TOPIC: for- + while-loops
- ASSIGNMENT: create a 2D grid of custom shapes using a `for` loop.
- TOPIC: arrays + ArrayLists
    - @maybe bring cardboard box
    - 1D and 2D arrays ( example x + y coordinates )
- ASSIGNMENT: use an array to store the x-coordinates of 10 rectangles. Make them move left over time.

- OPTIONAL_ASSIGNMENT: draw 10 shapes which, one after the other, snaps to the current mouse x-position whenever the mouse is pressed
- OPTIONAL_ASSIGNMENT: print every keystroke to the terminal
- OPTIONAL_ASSIGNMENT: do a thing once and then have a loop do it 1024 times
- OPTIONAL_ASSIGNMENT: draw a pattern with a lot of shapes

- END_OF_DAY_ASSIGNMENT: make a drawing program like MS Paint

## BLOCK 03 "Classes"

note: demo touch screen with drawing programs

- TOPIC: built-in classes
    - fonts with `PFont` 
    - images with `PImage`
- ASSIGNMENT: load and display a font or image and display them on the screen.

- TOPIC: vectors with `PVector`
- ASSIGNMENT: simulate basic physics by making a ball fall using a `PVector` for position + velocity.

- TOPIC: dynamic arrays with `ArrayList`
- NOTE: removing elements from callback functions can be dangerous
- ASSIGNMENT: create an `ArrayList` of circles. pressing the mouse should add a new circle at the current mouse position.

- TOPIC: custom classes
- ASSIGNMENT: design a `Ball` class with properties for position and speed and a *move* function. Create multiple instances, store them in an array/ArrayList, and make them move independently.

- OPTIONAL_ASSIGNMENT: make a doodle pad trace mouse movement with two different stroke sizes
- OPTIONAL_ASSIGNMENT: create a program where you draw bouncing shapes using a class stored in an array

- END_OF_DAY_ASSIGNMENT: create an interactive sketch with multiple custom classes, including dynamic behavior ( e.g a mini ecosystem of bouncing objects ).

## BLOCK 04 "Libraries+Drawing"

- dpp: write one sketch with VS Code
- dpp: use LLM once for debugging

- TOPIC: ( built-in ) libraries e.g
    - PDF Export
    - Serial
- ASSIGNMENT: export a simple drawing as a PDF file.
- TOPIC: contributed libraries
    - GUIs with *controlP5*
    - sounds with *Wellen*
    - particle simulation with *Teilchen*
- ASSIGNMENT: add background music or sound effects to your sketch using a sound library.
- TOPIC: load + save data
    - CSV tables with `Table`
- ASSIGNMENT: load a CSV file of colors and use them to draw a pattern.
- TOPIC: advanced drawing
    - shape + vertex
    - translate + rotate + scale + push/pop
    - offscreen drawing with `PGraphics`
- ASSIGNMENT: use `translate` and `rotate` to create a windmill animation.

## BLOCK 05 "Code Jam"

- TOPIC: refactoring @note(dpp, "kind of done this inline already")
- ASSIGNMENT: take an old sketch and reorganize it into smaller, reusable functions.
- ASSIGNMENT: doodle around with your own and somebody else code @todo(maybe this is a nice end-of-day assignment for the weekend based on VJ code)

- END_OF_DAY_ASSIGNMENT: Code Jam -- Build a VJ Tool
    - location: in attrium on big LED
    - fixed resolution: 720p ( i.e 1280×720 )
    - fullscreen: with `fullscreen()` + `noCursor()`
    - audio input: laptop microphone or ears
    - duration: approx 1 minute

### Expert Knowledge

@note(add where and when it fits.)

- modulo ( in counters )
- bit operations
- matrix transformation ( see `MatrixTransform.pde` )
- processing in C++/Python/JavaScript ( i.e Umgebung )
- processing as an idea
- other programming concepts/languages e.g shaders (GLSL)

---

## Lecturer Notes

- make sure that each block ( or topic within a block ) is not too long ( e.g have people work on assigments approx every 45min )
- ASSIGNMENTS distinguish between INTERMEDIATE (INT) + END_OF_DAY (EOD)
    - INT :: "just a few minutes to recap what was just discussed" can also be used to help students in individual discussions
    - EOD :: "assignment, optional for those who want to try"
- *microexcursion* will be added on demand where and whenever it fits. 