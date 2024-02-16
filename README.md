<div align="center">
<!-- TODO: add link to website once it is ready -->
<h1><a href="https://getpos.in" _blank=true>Get POS</a></h1>
Simple, yet powerful POS solutions for businesses
</div>

# Get POS Flutter App

## About

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" /> 
<img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" />

A cloud-based Get POS solution is a computerized system designed for your retail store, restaurant, multi-store, and supermarket to manage transactions, orders, inventory, and in-store product sales in one go.

This custom POS system is built to increase revenue and save time for every retail and hospitality business chain that offers multi-location features such as inventory transfers, network pricing, and advanced reports.

It builds on top of ERPNext and the Frappe Framework - incredible FOSS projects built and maintained by the incredible folks at Frappe. Go check these out if you haven't already!

### Features

1. Offline Syncing
2. Inventory Management
3. Order Management
4. Employee Management
5. Supplier Management
6. Reporting
7. Accounts & Payroll
8. Multi-location Management

## Project Requirements and Dependencies

The very first requirement to run this mobile app is, that you should set up the active & working Frappe ERPNext instance. To set up the ERPNext you can visit [here](https://github.com/nestorbird/GETPOS#readme).


## Frappe Installation

Once you've [set up a Frappe site](https://frappeframework.com/docs/v14/user/en/installation/), installing GETPOS is simple:


1. Download the app using the Bench CLI.

    ```bash
    bench get-app --branch [branch name] 
    ```

    Replace `[branch name]` with the appropriate branch as per your setup:

    | Frappe Branch | GETPOS Branch           |
    |---------------|-------------------------|
    | version-14    | production              |
    | develop       | deployment-development  |
    | version-13    | production              |

    If it isn't specified, the `--branch` option will default to `deployment-development`.

2. Install the app on your site.

    ```bash
    bench --site [site name] install-app nbpos
    ```

## App Downloads

iOS App - [Click here](https://testflight.apple.com/join/m8xtCYGn)

Android App - [Click here](https://play.google.com/store/apps/details?id=com.nestorbird.nb_pos)

### Pre-Requisites at Flutter end - 

1. [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
2. Flutter SDK installation
3. Android SDK
4. [XCode](https://developer.apple.com/xcode/) (if working on MacOS for iOS)
5. Apple SDK (if working on MacOS for iOS)
6. Virtual or physical Android or iOS Device for testing

## How to Setup and Run the Mobile App in Android Studio, IntelliJ Idea & Visual Studio Code

Follow the following steps to set up and run the mobile app -

1. First, clone the project from the [master branch](https://github.com/nestorbird/Get-POS-Flutter-App).
2. Open the project in Android Studio or in Visual Studio Code.
3. Open the terminal and run the command - ```flutter pub get```. This command will remove all the errors that you are getting in the project.
4. Select the target device from the device explorer menu.
5. Run the project by pressing Function + F5 or execute the command - ```flutter run``` from the terminal.
