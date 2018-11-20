# Veleza SDK
SDK with integratable Veleza UGC widgets

## Photos & Surveys
[Photos & Surveys widget](VelezaSDK/Widgets/VelezaSurveysPhotosWidget.swift) displays people photos with looks, where given product has been used, and survey ratings about various features of the product.

To use this widget, add **VelezaSurveysPhotosWidget** view to your controller and set product's GTIN:

```swift
import VelezaSDK

...

let widget = VelezaSurveysPhotosWidget()

view.addSubview(widget)
/** ... add view constraints ... */

/** Set product GTIN.
 *  Once this property is set, widget will request information from API and display it.
 */
widget.identifier = "00689304051019"

```

If Veleza does not have the requested product or any UGC associated with it, widget won't display anything. 
Sometimes you may want to do something if widget has no information to display. 
To do that, you may use [VelezaWidgetDelegate](VelezaSDK/Widgets/VelezaWidget.swift) protocol. This protocol
requires to implement 2 methods:

```swift
...
    widget.delegate = self
...

    /** 
     *  This method is called once widget got the response from API
     */
    func velezaWidget(_ widget: VelezaWidget, shouldBeDisplayed: Bool) {
    
        /**
         *  Hide activity indicator here, etc.
         */
        
        if shouldBeDisplayed {
            /**
             *  Widget is ready to be displayed
             */
        }
        else {
            /**
             *  Widget won't display anything, display something else here
             */
        }
    }

    /** 
     *  This method is called when widget constraints has been updated 
     *  and container should be updated.
     */
    func velezaWidget(needsLayoutUpdateFor widget: VelezaWidget) {
        /** 
         *  Call layoutIfNeeded() on container or do some other layout things here.
         *  For example, update UITableView constraints:
         */
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
```

To see more ways to use the widget and it's configurations, look into [example project](Example/) included in this repository.
[Example project](Example/) contains examples how to use widget in UITableView & displays examples of different configurations.


## Installation

### CocoaPods

Add VelezaSDK to your `Podfile` and run `pod install`:

    pod 'VelezaSDK', :git => 'https://github.com/Veleza/Veleza-SDK-iOS.git'
