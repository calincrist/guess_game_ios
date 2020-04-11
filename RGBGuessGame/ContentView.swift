//
//  ContentView.swift
//  RGBGuessGame
//
//  Created by Calin Ciubotariu on 11/04/2020.
//  Copyright © 2020 Calin Ciubotariu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let redTarget = Double.random(in: 0..<1)
    let blueTarget = Double.random(in: 0..<1)
    let greenTarget = Double.random(in: 0..<1)
    
    //  MARK: - States
    //  ORDER MATTERS for the init
    @State var redGuess: Double
    @State var blueGuess: Double
    @State var greenGuess: Double
    @State var showAlert = false
    
    //  MARK: - Actions
    func computeScore() -> Int {
        let redDiff = redGuess - redTarget
        let blueDiff = blueGuess - blueTarget
        let greenDiff = greenGuess - greenTarget
        
        //  The diff value is just the distance between two points in three-dimensional space.
        //  You subtract it from 1, then scale it to a value out of 100.
        //  Smaller diff yields a higher score.
        let totalDiff = sqrt(pow(redDiff, 2) + pow(greenDiff, 2) + pow(blueDiff, 2))
        
        return Int((1.0 - totalDiff) * 100.0 + 0.5)
    }
    
    
    //  MARK: - body
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    VStack {
                        ZStack(alignment: .center) {
                            Color(red: redGuess, green: blueGuess, blue: greenGuess)
                            Text("60")
                                .padding(.all, 5)
                                .background(Color.black)
                                .mask(Circle())
                        }
                        self.showAlert ?
                            Text("R: \(Int(redGuess * 255)) G: \(Int(greenGuess * 255)) B: \(Int(blueGuess * 255))")
                            :
                            Text("Match this color")
                    }
                    VStack {
                        Color(red: redTarget, green: greenTarget, blue: blueTarget)
                        Text("R: \(Int(redTarget * 255)) G: \(Int(greenTarget * 255)) B: \(Int(blueTarget * 255))")
                    }
                }
                Button(action: {
                    self.showAlert = true
                }) {
                    Text("Hit Me!")
                }.alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text("Your score"),
                          message: Text(String(computeScore()))
                    )
                }.padding()
                
                VStack {
                    ColorSlider(value: $redGuess, textColor: .red)
                    ColorSlider(value: $greenGuess, textColor: .green)
                    ColorSlider(value: $blueGuess, textColor: .blue)
                }.padding(.horizontal)
            }
        }
        .navigationBarTitle("Da", displayMode: .large)
        .navigationBarHidden(false)
        .environment(\.colorScheme, .dark)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(redGuess: 0.8, blueGuess: 0.1, greenGuess: 0.3)
            .previewLayout(.fixed(width: 568, height: 320))
//            .environment(\.colorScheme, .dark)
    }
}
#endif


struct ColorSlider: View {
    
    //  Like props from RN
    @Binding var value: Double
    var textColor: Color
    
    var body: some View {
        HStack {
            Text("0").foregroundColor(textColor)
            Slider(value: $value)
            Text("255").foregroundColor(textColor)
        }
    }
}


/*
 ContentView_Previews contains a view that contains an instance of ContentView.
 This is where you can specify sample data for the preview, and you can compare different font sizes and color schemes.
 
 For landscape preview: ContentView().previewLayout(.fixed(width: 568, height: 320))
 https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
 
 SwiftUI is declarative: you declare how you want the UI to look, and SwiftUI converts your declarations into efficient code that gets the job done.
 Apple encourages you to create as many views as you need to keep your code easy to read.
 Reusable parameterized views are especially recommended—it's just like extracting code into a function, and you'll create one later in this chapter.
 
 SwiftUI vocabulary:
 - Canvas and Minimap
 - Container views
 - Modifiers
 
 Like RN - in SwiftUI you can't have more than one view at the top-level of body, so you'll need to put them into a container view—a VStack (vertical stack) in this scenario.
 
 Note: In IB, you could drag several objects onto the view, then select them all, and embed them in a stack view.
 But the SwiftUI Embed command only works on a single object.
 
 You can use "normal" constants and variables in SwiftUI, but if the UI should update when its value changes, you designate a variable as a @State variable.
 In SwiftUI, when a @State variable changes, the view invalidates its appearance and recomputes the body.
 To see this in action, you'll ensure the variables that affect the guess color are @State variables.
 
 **ORDER MATTERS for the init**
 
 Bindings:
`$` symbold — rGuess by itself is just the value—read-only.
 $rGuess is a *read-write* binding; you need it here, to update the guess color while the user is changing the slider's value.
 
 **Extract Subview**
 
 For the value variable, you use @Binding instead of @State, because the ColorSlider view doesn't own this data—it receives an initial value from its parent view and mutates it.
 
 
 The SwiftUI views update themselves whenever the slider values change!
 The UIKit app puts all that code into the slider action.
 Every @State variable is a source of truth, and views depend on state, not on a sequence of events.

 
 Again, like in RN: The action you want to happen is the presentation of an Alert view. But if you just create an Alert in the Button action, it won't do anything.
 
 Instead, you create the Alert as one of the subviews of ContentView, and add a @State variable of type Bool.
 Then you set the value of this variable to true when you want the Alert to appear—in the Button action, in this case.
 The value resets to false when the user dismisses the Alert.
 
 Add alert thorugh the `alert` modifier to the Button view. Finally, no UIAlertViewController bullshit
 
 Key points
 • The Xcode canvas lets you create your UI side-by-side with its code, and they stay in sync—a change to one side always updates the other side.
 • You can create your UI in code or in the canvas or using any combination of the tools.
 • You organize your view objects with horizontal and vertical stacks, just like using stack views in storyboards.
 • Preview lets you see how your app looks and behaves with different environment settings or initial data, and Live Preview lets you interact with your app without firing up Simulator.
 • You should aim to create reusable views — Xcode's Extract Subview tool makes this easy.
 • SwiftUI updates your UI whenever a @State variable's value changes. You pass a reference to a subview as a @Binding, allowing read-write access to the @State variable.
 • Presenting alerts is easy again.
 
 
 **Environment values**
 Several environment values affect your whole app. Many of these correspond to device user settings like accessibility, locale, calendar and color scheme. You'll usually try out environment values in previews, to anticipate and solve problems that might arise from these settings on a user's device.
 
 You can find a list of built-in EnvironmentValues at apple.co/2yJJk7T.
 .environment(\.colorScheme, .dark) modifier for darkmode
 
 
 Note: Adding modifiers in the right order
 SwiftUI applies modifiers in the order that you add them—adding a background color then padding produces a different visual effect than adding padding then background color.
 
  Slider(value: $value).background(textColor).cornerRadius(10)
 VS
  Slider(value: $value).cornerRadius(10).background(textColor)
 
 
 Using ZStack
 The Z-direction is perpendicular to the screen surface — items lower in a ZStack appear higher in the stack. It's similar to how the positive Y-direction in the window is down.
 
 
 
 SwiftUI provides several tools to help you manage the flow of data in your app.
 **Property wrappers** augment the behavior of variables.
 SwiftUI-specific wrappers used to declare a view's dependency on the data represented by the variable.
• @State,
 @State variables are owned by the view. @State var allocates persistent storage, so you must initialize its value. Apple advises you to mark these private to emphasize that a @State variable is owned and managed by that view specifically.
 Note: You can initialize the @State variables in ContentView to remove the need to pass parameters from SceneDelegate.
        Otherwise, if you make them private, you won't be able to initialize ContentView as the root view.
 
• @Binding,
 @Binding declares dependency on a @State var owned by another view, which uses the $ prefix to pass a binding to this state variable to another view.
 In the receiving view, @Binding var is a reference to the data, so it doesn't need an initial value.
 This reference enables the view to edit the state of any view that depends on this data.
 
 
• @ObservedObject
 @ObservedObject declares dependency on a reference type that conforms to the ObservableObject protocol: It implements an objectWillChange property to publish changes to its data.
 e.g. Implemented the timer as an ObservableObject.
 
• @EnvironmentObject
 @EnvironmentObject declares dependency on some shared data—data that's visible to all views in the app.
 It's a convenient way to pass data indirectly, instead of passing data from parent view to child to grandchild, especially if the child view doesn't need it.
 Context API from RN (?)
 
 Note: You normally don't use @State variables in a reusable view—use @Binding or @ObservedObject instead.
 You should create a private @State var only if the view should own the data, like the highlighted property of Button.
 **Think** about whether the data should be owned by a parent view or by an external source.


 
 */
