---
layout: post
title: Direct Android development learning
---

Part 1: The Introduction

Let me preface everything you're about to read with the fact that this will be very informationally dense. There will be a lot of resources that you need to go through, and it will appear to be very daunting, but by no means is it going to be impossible. Thanks.

So, you want to learn how to become an Android developer? A little background, I've been working on an Android app professionally for a few months shy of a full year. In that time I've learned a tremendous amount, and made a horrifying number of mistakes. One of my coworkers is interested in taking up learning Android, so I want to dump as much useful information as I can into this post. This serves two purposes, the first being that I'll have systematically gone through everything I did so that he can use it as a reference, and two it'll let me explicitly go through all the things that I'll need to explain, but let me do it ahead of time instead of in real time. This post will be lengthy, but I still hope it'll be useful. I will also only expand upon topics that I've had personal experience with, so there are plenty of incredibly valuable libraries and tools that I will not cover. Unfortunately, you'll have to read about those elsewhere. In the same vein, reading this post alone is not going to make you a proficient Android developer. This post is designed to give you a rough overview of what I've learned. External resources will be abundant throughout the post.

Let's start at the [beginning](http://www.androidcentral.com/android-history). Android is a mobile phone operating system that started with the goal to be a way for phone manufacturer's to have a universal operating system. The operating system would be free, and so the manufacturer's wouldn't have to create their own or pay expensive licensing fees. As such, it needed to run on as many hardware platforms as possible. This made the Java Virtual Machine (JVM) a perfect platform to use, since the point of the JVM was to "Write once, run anywhere". The operating system is built on a Linux kernel, but the apps and such run on the JVM layer which is what you're likely to interface with if you write apps. You can access lower level subroutines using the Native Development Kit, but that's out of the scope of this post.

Let's talk about developing for Android a bit. You'll likely be writing everything in Java, however Scala and more recently Kotlin are both languages that are also used. All three of these are JVM languages, which means you get your garbage collector which can be pretty useful. Java is your typical OOP language, whereas Scala and Kotlin are multiparadigm languages that are heavily influenced by functional principles. The Android SDK that you'll have to work with, is implemented in Java, and tends to be heavily opinionated to having you write code in a specific way. I've never used Scala, and I've only played with Kotlin, so I'll really only be talking within the context of Java.

Before we talk more about the Android SDK, I want to interject a little with the tools you might encounter. For a while, the weapon of choice for developing Android apps was to use the Eclipse IDE with an Android development plugin. This has since been discontinued and is no longer being supported as a valid way to develop for the Android platform. Nowadays, you will typically see Android Studio used as your IDE. Android Studio is a fork off the extremely popular IntelliJ IDE by JetBrains. JetBrains makes a suite of phenomenal IDEs for all kinds of languages and developmetn tool chains. Android Studio is developed by Google engineers, but definitely benefits from the amazing features that are available in JetBrains. Alongside Android Studio, you'll likely be building your code using the Gradle build system. Gradle is a horrific monster of a build system, but with that being said I don't really know of any build systems that aren't massive and sluggish. That's not being entirely fair since Gradle has equally monstrous capabilities as opposed to a build system like Make. Gradle will manage your dependencies for you, compress and minify assets, and help you build your Android app. It's so configurable that you can have an infinite amount of different apps built with only a few lines of configuration. For example, a version of the app which free features versus non-free features. Gradle is incredibly slow, and I'll touch upon things to mitigate that. Lastly, I want to point out that you're likely going to be writing code with Java 7, even though Java 8 is fairly old. Recent Android versions will be able to use Java 8, but that's just not the normal case right now. Though, you'll find soon that some of the best features of Java 8 are available through other means. (Lambdas anyone?)

And at last, let's get to the meat and potatoes of Android development, working with the Android Software Developmetn Kit (SDK). The SDK provides you with an interface to communicate with the operating system, design user interfaces, communicate with different hardware sensors, and much more. The SDK is very opinionated, and you'll quickly have to learn how to write code in such a way that makes it easier for you to work with this SDK. Android user interfaces can be done programmatically, but the more frequent way of creating them is by writing XML files that denote how user interfaces will appear.

For example, you might see a snippet like so:  
{% gist abatilo/2d2ccd826286d42fce2f8a2b8d3982fd %}

In it's full context, this is how you would describe a label of text to show up on the user interface. You'll notice that element attributes are used to describe the View itself. People who are familiar with web development shouldn't feel too out of sync here.

Once you have your user intefaces, you can have Activities or Fragments (gross, you'll see) that will _inflate_ your intefaces on to the screen. Once those are available, it'll be up to you to write the code that tells the OS what different actions should do.

At it's simplest level, this is the essence of Android development. It's not so bad yet.

Part 2: Getting more meat

The basics aren't super hard to understand. You define interfaces in XML, and you write Java code to denote what the interfaces can do. Let's get to know the common moving parts you'll come across while developing Android apps.

Android apps open to an instance of an _Application_. Applications can create instances of _Activities_, and _Activities_ can create _Fragments_. You should only have a single Application instance. You can choose to specify a class that gets instantiated as an Application, which is useful for initializing variables that need to be available right from the very beginning. For example, I use a library called Crashlytics for logging events and reporting crashes. I initialize Crashlytics during the creation of the Application. You can choose to not specify one and have a default one get created. Another reason you might need to create a custom Application is in the case of [multidexing](https://developer.android.com/studio/build/multidex.html) your app. _Multidex_ is when your app needs to store references to over 64,000 methods. This seems like a lot but it's surprisingly easy to hit that limit when you start including libraries. Some production grade libraries can easily carry 1,000 methods, and some even have over 10,000 methods. You can read more in the link above.

In your Application, you have [Activities](https://developer.android.com/reference/android/app/Activity.html). Activities are the power house of the Android application, where you start to really call on all sorts of other functions and methods, where your interface logic can be, etc. Activities can get very hairy though because of what's called the [Activity Lifecycle](https://developer.android.com/guide/components/activities/activity-lifecycle.html). Basically, an Activity's state varies greatly based on what a user is doing on their phone. You're notified about the state of an activity through call backs, which are the methods that make up that Activity Lifecycle. You'll know when an Activity is first created, when it's process might be paused, resumed, stopped, destroyed, and a couple others. These are important because they inform you of actions such as the app has been backgrounded, but the user expects to be able to switch back to the application and resume it quickly. So you need to suspend the state of your app. A common mistake for new Android developers is to treat the Activity instance like a God object. Activities have references for many of the things you might want to use. For example, they provide an instance of a [Context](https://developer.android.com/reference/android/content/Context.html) which is an interface for global information. Activities also provide a means of being able to navigate the UI resource tree, and much much more. You most definitely don't want to have your Activity be a God object. That's just poor design and becomes cluttered quickly. It's easy to do though because of how powerful Activities are. I'll touch upon how to get around this later on when I talk about popular ways to architect your Android code.

Fragments are extremely similar to Activities, but are not entirely the same. Fragments cannot exist without a _parent_ Activity. You see, Activities will be inflated to run on the entire screen of the phone. Fragments were designed to be reusable bits of space on the screen. For example, think of a tablet device. Android is meant to be a universal system so tablets are supposed to be treated with the same respect as a mobile phone. The screen size or density should not matter to an Android application because everything should adapt dynamically. With that being said, a tablet, with it's much larger screen, can have more views visible on said screen at any given time. Fragments were created in order to have what might be seen as _sub-activities_. Imagine a screen with two boxes on it. Maybe one has a user's photo and the other has their name in it. If you were on a tablet, you could have enough room to have their name and address. In other words, these individual boxes can be used differently based on your context. And yes, I know, there are other ways around this. You can have conditions for how you create or populate the views, but that tends to become fairly messy code anyways. So, to solve this, the Android team made Fragments, and then pushed them very hard to be the only way you should handle reusable portions of screens. They were very adamant that this was the best way to achieve maximum reusability. Unfortuantely, it became clear very quickly that Fragments are in fact a terrible mess. Fragments themselves also have individual lifecycles, and they're much more fickle in terms of when the different lifecycle methods may be called. It's not as clear as, the user hits the home button which backgrounds your app. Instead it might be that you've scrolled far enough away from a particular fragment which causes it to be paused. Another problem with this approach is the fact that sometimes one fragment wants to know about what's happening in another fragment. Since they're instances within the Activity, now you have to pass the references up to the Activity and relay that information down into another fragment. If you try to communicate directly with another fragment, then you've just created a circular dependency which has a hilariously high chance of causing a memory leak. The garbage collector sees that someone else is still using memory that belongs to the first fragment, so it can't actually deallocate the fragment in its entirety. It's important to note, memory leaks can still happen if you pass things up to the Activity. The whole lifecycle process is very prone to memory leaks, which might not matter for small apps, but can cause major problems if you're using a lot of memory. Our app at work interfaces with smart IP enabled cameras, and images are definitely a major chunk of memory.

Whether you're a the Fragment level or the Activity level, you'll be inflating what are called [Views](https://developer.android.com/reference/android/view/View.html). Views are the individual pieces that make up a user interface. Maybe think of them like individual <div> tags in HTML. As a programmer, you'll have to transform and manipulate data in such a way that you can display the data on these views. You'll have to get a reference to the View in question, and then set its properties. You'll see examples of this everywhere so I won't waste the time. I will talk about cleaner ways to do this later though. Anyways, you have your regular Views, and then you have complex Views with complex data structures that need to be displayed. In this case, you'll use what's called an [Adapter](https://developer.android.com/reference/android/view/View.html). Adapters are basically just a way to bridge between your complex data to your complex Views. You'll commonly see Adapters in the context of having a list of items. You don't want to have to write code to manually populate data to every visible View in the list, so we're given adapters by the SDK which let's you hand it a list of items, and then the logic for how to populate one list item. Some Views are smart in how they manage the views and memory as well. For example, the [RecyclerView](https://developer.android.com/training/material/lists-cards.html) which is still a relatively new thing in the Android SDK, can recycle memory for displaying views. Imagine if you had 100 items that needed to be displayed. The previous incarnation, the ListView, would allocate memory for all 100 items, or at least it would try to. This became a problem, and people found clever ways to only allocate enough memory for what needed to be displayed. Then once something was scrolled off screen, those resources would be used for the next thing to be displayed. Effectively creating a cache pool for resources. RecyclerViews will now do that automaticallyor you, and you just specify in the adapter how to use and reuse the components.

Now, you'll find a lot of views in Android apps are found using a method called `findViewById()`, which will navigate your current location in the view hierarchy, and try to find the view you've given. Oh yeah, view hierarchies. Views are connected like a graph, and navigating through that graph can be a nightmare. If your graph is too large then you run into problems of how long the traversals take. This means that an Android friendly  designer will be aware of that and work with you to create a flat, non-nested UI. Unfortunately, this isn't always the case. Hitting 60fps isn't everyone's priority, even though it's been proven that smooth apps are used more. *sigh* Anyways, people have found nicer ways to manage your views and easily grab references to them, reducing boilerplate code. Once such library, which I use extensively, is called [ButterKnife](http://jakewharton.github.io/butterknife/). ButterKnife uses Dependency Injection, which I'll talk about, to make it very easy to grab references to available Views. The other way you'll see grabbing views is through DataBinding. DataBinding is associated with the MVVM (Model-View-ViewModel) code architecture, which basically directly ties your interfaces with data. It's almost like instead of giving a view the data to display, you give the view a reference to the memory where the value is stored, which means any time that data changes, the View is updated instantly with no code, or very little code needing to be written. DataBinding is great, and I've used it, but it's a new feature and it actually slows down compilation time noticeably because the DataBinding library in the background will regenerate the binding code behind the scenes for you.

That's a great accidental segway. Java, and Android development by extension, is a huge proponent of automatic code generation. The code to be generated is specified by annotations which are denoted with the `@` symbol. If you looked at the ButterKnife documentation, you'll see the `@` in several places. As part of the build system with Android, Gradle can do what's called _annotation processing_ which can be considered very similar to using `#define` or macros in general in a language like C/++. It's a text pre-processing step which does increase compile time, but man does it reduce code surface area. I love reducing code surface area. Any additional lines of code are just additional vectors where you might make a mistake. Annotation processing and code generation libraries are mostly targetted for replacing very mundane and repetitive tasks, which are the easiest to slip up at because they're so boring.

Let's talk about Dependency Injection. I use a library called [Dagger2](https://google.github.io/dagger/) which is a library that's developed by Google, and not to be confused with Dagger which is an old version of the library that was maintained by Square. Dependency Injection is a very simple concept. In essence, it's just passing information around. For example, you might want to pass in the instance of a WebSocket into different parts of the UI/their adapters. You could do this by passing in a reference to the socket in through each constructor, but for something that's globally used like a WebSocket instance or perhaps a global data model of state (a la Redux), it would be tedious to have to write the variable and pass it into dozens if not hundreds of constructors. Here's where Dagger2 comes in handy. It's a compile time annotation processing way to pass something along like that, in the most tiny amount of code ever.

- ReactiveX
- Lamdas, retrolambda
- Chet Haase blog posts
- Effective Java by Joshua Bloch
- Fragmented podcast