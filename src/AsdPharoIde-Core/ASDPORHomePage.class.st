Class {
	#name : #ASDPORHomePage,
	#superclass : #ASDPORPageLogin,
	#category : #'AsdPharoIde-Core-Web'
}

{ #category : #accessing }
ASDPORHomePage class >> pageName [
	^ 'Home'
]

{ #category : #accessing }
ASDPORHomePage class >> priority [
	^ 1
]

{ #category : #initialize }
ASDPORHomePage >> initialize [

	super initialize.
	self session rootComponent header: ASDBPORHeaderClassBrowser new.
]

{ #category : #rendering }
ASDPORHomePage >> renderContentOn: html [

	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ 
			html mdlCell
				middle;
				size: 12;
				with: [ 	html div
		mdlTypographyTextJustify;
		with:
				[ #('display-4' 'display-3' 'display-2' 'display-1' 'headline' 'title' 'subhead' 'body-2' 'body-1' 'body-2-Force-Preferred-Font' 'body-1-Force-Preferred-Font' 'caption' 'caption-Force-Preferred-Font' 'menu' 'button')
				do: [ :each | 
					| selector |
					selector := ('mdlTypography' , (each capitalized copyReplaceAll: '-' with: '' )) asSymbol.	"For example `#mdlTypographyCaptionForcePreferredFont`"
					html div
						style: 'margin: 10px 0;';
						perform: selector;
						with: each asLowercase capitalized ] ] ]
			]
]
