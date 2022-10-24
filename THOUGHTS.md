# The process

- [The process](#the-process)
    - [User Story:](#user-story)
    - [Preface](#preface)
    - [0 Getting request, checking, making a drawings on all I got](#0-getting-request-checking-making-a-drawings-on-all-i-got)
    - [1 Creating an app, making first request inside it and display onscreen.](#1-creating-an-app-making-first-request-inside-it-and-display-onscreen)
    - [2 Prototyping UI](#2-prototyping-ui)
    - [3 Adding business logic](#3-adding-business-logic)
    - [What's done after 4 hrs](#whats-done-after-4-hrs)
  - [After 4 hrs](#after-4-hrs)
      - [Timeline](#timeline)
  - [Total project time is 5hr 10min](#total-project-time-is-5hr-10min)

### User Story:

As a working student, I would like to buy a decent used car without leaving my couch. To do that, I would like to be able to browse used cars on an app, with enough information for me to decide which one is best.

API + Schema
No design

---

### Preface

I consider our current feedback loop to be slow, so I would rather not come for details. Just making my assumptions and declare some points in this file.

- Backend is out of my boundaries. I consider it a third party service where I can't change anything right now
  - In my daily job I would of course start with discussion about the user story, provided data from a backend and what would be useful.
- I wanted to become a designer, but it's not my daily job and I didn't practice for years, so I think my process of making UI would be better with SwiftUI/UIKit prototyping in an app, not tldraw/figma or anything else
- I'll try to make it in 4 hrs with timeline

### 0 Getting request, checking, making a drawings on all I got

Checked schema, checked details I got from a backend

- It would be a lot more cars on a real app, so
  - There should be pagination
  - I should be able to filter things via query, not locally

Checked autoscout24 filter on website. It has a lot of other fields that could help customers, but I can't add it to the api, so won't be bothered about it.

Tried to add query into request, found api docs, there is nothing to query there :)

- The images are in different sizes, that's strange. Ideally I would want to provide backend with my sizes of a view where image would fit, and it would return image with required size.
- firstRegistration format is not something I saw before. It's a month for sure, but Codable in iOS would not be able to parse it, so I would choose String and then would probably convert it into Date or format somehow. Will get to it later. String would be okay for start.
- I don't know measurement types for mileage and price. I consider it to be EUR and KM.
- We have optional fields, but nothing strange there.

Now I'll make a list of provided data and would think how it could fit into list and details screens.

Yeah, it should probably be a split view controller with master-detail views where

- List should have
  - search
  - filters
  - different states for empty search query, empty list, loading and others. Won't make error screen for networking issues in this example.
  - collection of elements displaying, probably:
    - model,make,color,registration date
    - price
    - type of seller if provided
    - mileage (if it fits)
    - fuel if it fits(icon?)
    - call button?
    - tappable card for details opening
- Details should contain all info we have on a car
  - call button
  - probably a like/subscribe button? for further searches, notifications or any other feature with subscribed cars.
  - Based on checking as24 - share?
    - Share would be great to be not just a link, but a screenshot of details view with car
  - carousel with similar cars? same model+make, probably?
- Supports iPad, macOS on Apple Silicon

What a working student and decent car in user story could mean?

- Sorting by price?
- Filtering out by price limit? Other fitlers would be less useful for a **decent** purchase

### 1 Creating an app, making first request inside it and display onscreen.

App is network based

I do want to use async await, kean/Get because I like it for simplicity. Could be simple URLSession too, but I just want to try libs I wanted to try for some time. Hope it's okay. I do see we don't need to overcomplicate, but I believe kean/Get would let me go as fast as with simple URLSession.

Will use [TCA](https://github.com/pointfreeco/swift-composable-architecture) probably, cause want to use it in production right now. It will provide me with

- View layer logic
- Testability of logic (though I would probably need only hard filtering, not anything else)
- Dependency management of services (networking mainly)

SwiftUI or UIKit?

I would love to experiment and make a simple example on SwiftUI, but I think it would be better to showcase my layout skill.

So UIKit. Navigation and a details. Probably will make only some views with SwiftUI. Details screen?

Will go with iOS 15+, cause last+1 rule. It could be 14+ without issues, I think too. But just don't want to spend time checking app in iOS 14 too.

So I start with Networking and Decodable model

Filled a Decodable model using json spec.

- Spec doesn't include Seller model. Why? Filled with data I saw in response
- API resource is not secure, so I had to add App Transport Security into Info.plist
  - Taking long, cause just allowing everything doesn't work. Have to spend time on this.

<details>
<summary>How I fixed issues with ATS</summary>

Changed url to use https, not http as given in email.

Fixed in Info.plist:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
	<key>NSAllowsArbitraryLoadsForMedia</key>
	<true/>
</dict>
</plist>
```

And in Capabilities -> Outgoing connections (Client):
![](./assets/capabilities.png)

</details>

After fixes found out `colour` field is not in json spec too. Had to change it to optional.

Added [swift-custom-dump](https://github.com/pointfreeco/swift-custom-dump) module for better messages. It was fast.

firstRegistration in spec is required, but it's actually not present in every item.

So it's:

- Spec doesn't include `Seller`, `colour`
- Spec marks `firstRegistration` as required, but it's optional.

Result of first step is actually checking data is coming with macOS app :)

<details><summary>Screenshots</summary>
<img src="./assets/1-mac.png"/>
<img src="./assets/1-iphone.png"/>
<img src="./assets/1-ipad.png"/>
</details>

### 2 Prototyping UI

I'll start with state definition without any architecture for now

Checked docs, composable architecture for example on nav, handled mess with navigation link.

2hrs 30mins already passed

...

Made master screen with SwiftUI.
Will make details with UIKit

Navigation is now in SwiftUI, but probably I should rewrite it to UIKit that I can control well) No time for that for now.

Next steps should be:

- Details screen UI in UIKit
- Filter/search UI in List
- Filter/search logic in List
  - Should I rewrite to TCA? :)
  - Or it would be enough to just do some functions where I would control complexity with pureness. Will see.

Started working on UIKit Details version. Won't have time for carousel so would make stacks :)

Did use [kean/Align](https://github.com/kean/Align) cause I like it interface for speed. Made easy scrollable stack view

Decided to write a small test for view state init and then add more info in it. It's a pure function so it's easy to test and good to lock it's transofrmation as a snapshot.

Used custom dump with diff for tests

Will add a test on search/filter later too.

By now it's 3hr 35min

btw, image loading is done with [Nuke](https://github.com/kean/Nuke) and it's view components LazyImage, LazyImageView.

---

I guess it's time to

### 3 Adding business logic

Will add better UI stacks and other sugar for details screen later.

Now it's time to add search/filter components and add business logic to filter/search

CarResponse was OK till now, but usually I make models for each different layer and transform them around.

API -> Database -> Domain -> View
Usually it's like that. Model for each layer, where it's easier to manipulate with different types.
API would use String almost everywhere cause it's JSON format.
Domain would add total enums, remove impossible cases from model and add throwing/logging logic to know about issues in decoding/transforming to domain.
Can elaborate in talk :)

Now I'm going to write UI for search.

Commit [fcf581883b7daf142ba583c6033a09159986f415](https://github.com/AgapovOne/carshow/commit/fcf581883b7daf142ba583c6033a09159986f415) is exactly 4 hrs of work.

Timeline:

- [ ] Start 13:45
- [ ] Pause at 14:15
- [ ] Continued at 14:35
- [ ] 15:15 pause
- [ ] 15:25 continued
- [ ] 16:16 paused
- [ ] 30+40+50=120
- [ ] 20 min +
- [ ] 23:03 start
- [ ] 23:53 pause
- [ ] 23:56 continue
- [ ] 00:20 finished test
- [ ] 120+20+50+25=215. 3hrs 35 mins
- [ ] 00:31 start
- [ ] 01:06 pause. mark 4 hrs of clean work time

---

### What's done after 4 hrs

[VIDEO](./assets/4hrs.mp4)

https://user-images.githubusercontent.com/4246455/197362007-a76b56a8-7a1c-4fb8-b871-af763aad3333.mp4

- Navigation. It would be better to have it in UIKit, but I spent less than a minute on that. In a real world would use FlowControllers in UIKit, use UISplitViewController
- Master layout in SwiftUI. Had issues with navigation link placement, checked in example of TCA, I think it's okay now, but it SwiftUI, so not ideal. Should show something in details screen on app open in iPad where details is visible at start.
- Details layout in UIKit. Showed how I control view state, how I transform domain model, add formatting and reconfigure views with stacks. Used a little of Auto Layout, but it's an easy one here. Would have problems with multiple labels placement, but it could be fixed with priorities. Or I could build a big NSAttributedString with text view, but lose possibility of placing labels on different edges :)
- Added simple test. Might be redundant, just wanted to show I do them, but it's useless for example project. Would add it on real project, cause it fixes behaviour so no other dev would break it by mistake.

What's left:

- UI for search/filtering. It should be search bar and button with a form and two text fields on min and max car price. Everything else could not fit into 4-6 hrs of work.
- Logic for search/filtering. I won't use TCA for now cause all logic actually is setting search text, then filtering app state cars with get property. Filtering is already done. Hard rules for filters could be there, like multiple case insensitive contains, fuzzy search, filtering by price range. Would add a test for that, but it's all about input and output. Too easy to test in that size of an application.
- Better UI :) Sky is the limit. Probably not needed, cause I showed a lot. Can add uilabel placement and avoid all warnings. Also clean up a little. Navbars, prettiness of current views,
- View states. Error, loading, empty, message displays.
- Add to favorites in persistent storage and display status on car

## After 4 hrs

I'll allow myself to spend 1 or 1.5 more hrs. Version after exactly 4 hrs is there if time is the main criteria.

Reread the task. It says **enough information to decide which one is best**.

So probably favourites is not the best idea, but sorting, filtering, searching might help a lot.

So I'll take on the task of making search, filter and sorting for the list. They would require no persistence, just pure logic.

---

So the steps on search were

1. Make a state with filters and sorting
2. Add logic
3. Write tests with measurement
4. Refine tests based on inputs
5. Add UI for search
6. Test on real app
7. Add UI for sorting (with SF Symbols slooow lookup)

---

#### Timeline

- [ ] 00:30 start
- [ ] Search commit in 01:15
- [ ] Pause at 01:24
- [ ] Continue 01:35
- [ ] Finished sorting 01:40

Total 1hr

So the next could be

- better UI for details screen
- Logic cleanup with dependencies showing how I would inject, test, control mess with mutations, form app persistence and state.

I decided to write it down.

I'm now all in for TCA. For a long time I implemented principles of UDF, State-driven ways, functional programming and Functional Core - Imperative Shell.

I do think that TCA

- controls state and mutations well (reducer and state)
- manages DI and dependencies (mocks, previews, real implementations are easy especially with new @Dependency)
- scales well with
  - performance - via making different stores, implementing isolated parts of stores, using diffing
  - readability - reducers are pure concepts where everything is handled. Tests are a documentation, well defined type system is the best checker for errors.

But navigation... I would still make it with UIKit and FlowControllers.

Done writing in 10 minutes.

## Total project time is 5hr 10min
