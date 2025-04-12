# StoryUI

Create stories with just single-line code

<a href="https://circleci.com/gh/badges/shields/tree/master">
        <img src="https://img.shields.io/circleci/project/github/badges/shields/master" alt="build status"></a>
        
## Installation

Use **Swift Package Manager**

```swift
dependencies: [
    .package(url: "https://github.com/tiskender2/StoryUI.git", exact: "1.6.1")
]
```
## Example 
![example](https://user-images.githubusercontent.com/17899883/166338390-ac5988fc-b417-4c41-b35a-8b18eca61eac.gif)
![](https://github.com/tiskender2/StoryUI/assets/17899883/80b08837-05da-48b0-92c2-b7b7000c8618)

## Usage

```swift
import SwiftUI
import StoryUI

struct ContentView: View {
    @State var isPresented: Bool = false
    @State var stories: [StoryUIModel] = [
        .init(
            user: .init(
                name: "Tolga İskender",
                image: "https://image.tmdb.org/t/p/original/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"
            ),
            stories: [
                .init(
                    mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
                    date: "30 min ago",
                    config: .init(
                        storyType: .message(
                            config: .init(showLikeButton: true),
                            emojis: [
                                ["😂","😮","😍"],
                                ["😢","👏","🔥"]
                            ],
                            placeholder: "Send Message"
                        ),
                        mediaType: .video
                    )
                ),
                .init(
                    mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                    date: "30 min ago",
                    config: .init(mediaType: .video)
                )
            ]
        )
    ]
    var body: some View {
        NavigationView {
            Button {
                isPresented = true
            } label: {
                Text("Show")
            }
            .fullScreenCover(isPresented: $isPresented) {
                StoryView(
                    stories: stories,
                    isPresented: $isPresented
                )
            }
        }

    }
}
```
## Requirements
- iOS 14+
- Swift 5.6+
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
StoryUI is available under the MIT license. See the LICENSE file for more info.
