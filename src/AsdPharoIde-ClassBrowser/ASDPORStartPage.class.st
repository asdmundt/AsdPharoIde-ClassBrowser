Class {
	#name : #ASDPORStartPage,
	#superclass : #ASDPORPage,
	#instVars : [
		'centerComponent',
		'loginComponent',
		'showLoginError'
	],
	#category : #'AsdPharoIde-ClassBrowser-Web'
}

{ #category : #accessing }
ASDPORStartPage class >> pageName [
	^ 'Home'
]

{ #category : #accessing }
ASDPORStartPage class >> priority [
	^ 1
]

{ #category : #accessing }
ASDPORStartPage >> centerComponent [
	^ centerComponent
]

{ #category : #accessing }
ASDPORStartPage >> centerComponent: anObject [
	centerComponent := anObject
]

{ #category : #accessing }
ASDPORStartPage >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #initialize }
ASDPORStartPage >> initialize [
	super initialize.

	
]

{ #category : #accessing }
ASDPORStartPage >> loginComponent [
	^ loginComponent
]

{ #category : #accessing }
ASDPORStartPage >> loginComponent: anObject [
	loginComponent := anObject
]

{ #category : #actions }
ASDPORStartPage >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORStartPage >> rendeModalLoginButtonOn: html [
	html
		form: [ html
				render:
					(ASDLoginCardWidget new
						callback:
								[ :login :password | self rootComponent tryConnectionWithLogin: login andPassword: password ];
						yourself) ].
	html anchor
		callback: [ self show: (WAInspector current on: self session) ];
		with: 'Inspect Session'
]

{ #category : #rendering }
ASDPORStartPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]

{ #category : #rendering }
ASDPORStartPage >> renderLoginErrorMessageIfAnyOn: html [
	self hasLoginError ifTrue: [
		showLoginError := false.
		html tbsAlert
			beDanger ;
			with: self loginErrorMessage ]
]
