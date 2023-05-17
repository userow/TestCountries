# TestCountries -  Test Task:

Finish the "TestCountries" application. 
The given version is partially complete:
added a list of countries as the database, 
created a simple UI with partial functionality.

## Source code:
https://drive.google.com/file/d/1Mj0H-AFDQ-ebXo-jojyUxrIpA0wDU0wv/view?usp=sharing

## Requirements:
1) Show a list of countries in a table. Sort by name.
2) Add searching functionality. Search for text in visible cells, and filter matching cells. The searched text should be highlighted.
3) Create a custom table cell. Add flag symbol and country code.
4) Add the bottom toolbar with two buttons: show/hide flag, show/hide country code.
5) Add a label to the toolbar to show how many countries are displayed when searched.
6) All actions with the table should be performed with animations.

##The result application should work like on the video:##
https://drive.google.com/file/d/1ce86yiNLf3VShZ1zIRUjsYl65qXKgt2a/view?usp=sharing

### **Additional requirements:**
* Don't use third party libraries.
* No interface builder.
* Conform to the current project coding styles.


## Thoughts after completion on NOT implemented functionality or futher improvements.

### Thoughts
[ ] No app architecture was pointed out, so implemented as is in ... I think MVC and tight coupled style. Probably should refactor with much clearer architecture.

[ ] Video hadn't shown if the table changed it's height from search bar to keyboard top. Though, definitely, no Toolbar were shown above keyboad during a search.

### Possible further Improvements
[ ] Moving data source to CountriesList from CountriesView (```_currentCountries: [CountryInfo]```)

[ ] Keyboard notifications + tableHeight changing

[ ] ??? label with country name with long text is not resized back after flag toggling on-off
