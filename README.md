# Weather Here

![App demo](https://github.com/almeidaws/weatherhere/blob/master/docs/Demo.gif?raw=true)

**Weather** is an iOS App that fetches weather data from [Open Weather](https://openweathermap.org/) and presents weather for current user's location. It also presents weather for cities nearby to user.

## Architecture

**MVVM** was chosen to avoid the massive view controllers and define a common vocabulary and a structure for the screens. [Combine](https://developer.apple.com/documentation/combine) was used for the required reactiveness defined by the architecture.

## Continuous Integration

Code regression is an important aspect of an application. All the tests are checked with [Travis CI](https://travis-ci.org/). You can check build status clicking on the following badge:

![Build Status](https://travis-ci.org/almeidaws/weatherhere.svg?branch=master)

## Tasks management

This was a standalone project, but there's no reason to keep all tasks in mind while coding. To solve this, a project on GitHub was created. That [project is public](https://github.com/almeidaws/weatherhere/projects/1).

![Task Management](https://github.com/almeidaws/weatherhere/blob/master/docs/task_management.png?raw=true)

## Dependency Injection

Controllers are completely independent of each other, and screens has no ideia about how data is persisted or what is used to fetch data from the Internet. In fact, on tests, an in-memory database is created and local files are read to ensure tests' quality.

For accomplish this, a module called **Services** was created. This module is very close to the intention of Factory Design Pattern. It allows many dependencies to be injected in the app when it opens, therefore making mocking entities is a trivial work.

**Injecting dependency**
![Injecting Dependency](https://github.com/almeidaws/weatherhere/blob/master/docs/dependency_injection_1.png?raw=true)

**Using abstract dependency**
![Using abstract dependency](https://github.com/almeidaws/weatherhere/blob/master/docs/dependency_injection_2.png?raw=true)

## Design

App's design was created on [Adobe XD](https://www.adobe.com/products/xd.html). iOS elements was used and as a consequence the app really looks like an iOS app. So the user feels comfortable using common patterns like pulling down lists to update and swipe to right for popping view controllers.

Besides of that, the app have 3 different background for one of those temperature: Hot, Cool and Cold.

![Adobe XD Image](https://github.com/almeidaws/weatherhere/blob/master/docs/adobe_xd.png?raw=true)

## Structure

Creating scalable apps is important, that means creating an entire app in one project is not a good ideia. Therefore, a workspace was created  with 6 projects inside of it managing a specific concern of the entire application.

![App's Structure](https://github.com/almeidaws/weatherhere/blob/master/docs/structure.png?raw=true)

- **Models**: contains value-type oriented entities used by the other modules. Using this approach allows a graceful communication between modules avoiding short-living entities when mapping data.
- **GPS**: abstract how user's location is fetched. This module isn't really decoupled from the project but it's useful for testing purpose.
- **Storage**: abstracts how data is persisted exposing an interface that permits, for example, creating an in-memory database whose is useful for testing purposes.
- **Networking**: abstracts how data is fetched from the Internet. There's no callbacks or delegates on this modules. The communication is entirely made with [Publishers](https://developer.apple.com/documentation/combine/publisher).
- **Service**: define utility methods used by other modules that make tasks like persistence and networking become highly decoupled.
- **UserInterface**: main module. It contains all app's screens and also a connection with all other modules. It's more or less like the Controller of MVC.

## Database

Data is locally persisted so the user can access data even when there's no Internet connection. Persistence is done with [SQLite](https://www.sqlite.org/index.html). Following is a diagram of the current database.

![App's Structure](https://github.com/almeidaws/weatherhere/blob/master/docs/database.png?raw=true)

## Dependency Manager

CocoaPods was chosen for code reuse. The app has only 2 crucial dependencies:

- **SnapKit**: used to working with auto layout and constraints, that is, saving time when creating screens and avoiding constraints errors.
- **SQLite**: used for persistence creating a good User Experience when there's no Internet connection. It also avoids managing database constraints by hand.

## Info.plist

There's two "environment variables" in this app:

- **BASE_URL_KEY**: API's host. Example `https://api.openweathermap.org/data/2.5`.
- **API_KEY**: API's key. Example: `97ebe639o5f61b292896acfaecf6e0af`.
