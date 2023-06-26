Class {
	#name : #ASDPORHomePage,
	#superclass : #ASDPORPageLogin,
	#category : #'AsdPharoIde-ClassBrowser-Web'
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

	
]

{ #category : #rendering }
ASDPORHomePage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]
