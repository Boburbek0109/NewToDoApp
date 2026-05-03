## About the Project

This is a SwiftUI ToDo app built to practice data persistence and app architecture.

In this project, I implemented:
- MVVM architecture with a separate ViewModel
- SwiftData for local data persistence
- Adding, deleting, completing, and favoriting tasks
- A separate Favorites screen
- A cleaner file structure with Model, View, and ViewModel layers
- Refactored the daily tasks screen into a cleaner tabbed structure
- Added `TaskPageView` for rendering task lists per tab
- Reworked `CustomTabView` to handle tab switching and horizontal paging
- Moved task filtering and empty-state text into `TaskViewModel`
- Updated the Daily Tasks entry point to open `TaskListView`

## What I Learned

While building this project, I learned how to connect SwiftData with a ViewModel, manage task state, save data locally, and separate UI logic from data logic.





https://github.com/user-attachments/assets/97689a6b-d515-489a-92b2-1ec8c6a01186





## Learning Resources

During development, I used documentation, articles, and tutorials to better understand SwiftData and MVVM.

Helpful resources:
- SwiftData + MVVM article: https://medium.com/@darrenthiores/the-ultimate-guide-to-swiftdata-in-mvvm-achieves-separation-of-concerns-12305f9e82d1
- https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-mvvm-to-separate-swiftdata-from-your-views
- https://www.youtube.com/@seanallen
- https://www.youtube.com/@SwiftfulThinking
- and also AI
