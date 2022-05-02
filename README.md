# StoryUI

Create stories with just single line code

## Installation

Use **Swift Package Manager**

```swift
dependencies: [
    .package(url: "https://github.com/tiskender2/StoryUI.git", exact: "1.0.0")
]
```
## Example 
![example](https://user-images.githubusercontent.com/17899883/166338390-ac5988fc-b417-4c41-b35a-8b18eca61eac.gif)


## Usage

```swift
import SwiftUI
import StoryUI

struct ContentView: View {
    @State var isPresented: Bool = false
    @State var stories = [
        StoryUIModel(user: User(name: "Tolga İskender", image: "https://image.tmdb.org/t/p/original/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"), stories: [
            Story(mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", date: "30 min ago", type: .video),
            Story(mediaURL: "https://image.tmdb.org/t/p/original//pThyQovXQrw2m0s9x82twj48Jq4.jpg", date: "1 hour ago", type: .image),
            Story(mediaURL: "https://image.tmdb.org/t/p/original/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg", date: "12 hour ago", type: .image)
        ]),
        StoryUIModel(user: User(name: "Jhon Doe", image: "https://image.tmdb.org/t/p/original//pThyQovXQrw2m0s9x82twj48Jq4.jpg"), stories: [
            Story(mediaURL: "https://picsum.photos/id/237/200/300", date: "12 hour ago", type: .image),
            Story(mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", date: "30 min ago", type: .video)
        ]),
    ]
var body: some View {
        NavigationView {
            Button {
                isPresented = true
            } label: {
                Text("Show")
            }
            .fullScreenCover(isPresented: $isPresented) {
                StoryView(stories: stories,
                          isPresented: $isPresented)
            }
        }

    }
```
## Requirements
- iOS 15+
- Swift 5.6+
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
