# MIFab
A simple fully customizable floating action button with options

<img src="demo.gif" height="500"/>

# Setup
- Copy the "MIFab" folder to your project.
- Create a new instance with a couple of lines of code
```
  var fabConfig = MIFab.Config()
        
  fabConfig.buttonImage = UIImage(named: "iconC")
  fabConfig.buttonBackgroundColor = UIColor.orange
        
  fab = MIFab(
    parentVC: self,
    config: fabConfig,
    options: [
      MIFabOption(
        title: "Item 2",
        image: UIImage(named: "iconB"),
        backgroundColor: UIColor.orange,
        tintColor: UIColor.white,
        actionClosure: {
                        
          let alertController = UIAlertController(title: "Demo", message: "Second fab button tapped", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
          self.present(alertController, animated: true, completion: nil)
                        
        }
      ),
      MIFabOption(
        title: "Item 1",
        image: UIImage(named: "iconA"),
        backgroundColor: UIColor.orange,
        tintColor: UIColor.white,
        actionClosure: {
                        
          let alertController = UIAlertController(title: "Demo", message: "First fab button tapped", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
          self.present(alertController, animated: true, completion: nil)
                        
        }
      )
    ]
)
```
- You can show or hide the fab with the methods
```
showButton(animated: Bool = false)
hideButton(animated: Bool = false)
```

- You can customize the UI by changing the config properties

# Demo
In this repository you can also find a demo.

# Info
If you like this git you can follow me here or on twitter :) [@MarioIannotta](http://www.twitter.com/marioiannotta)

Cheers from Italy!

