Class {
	#name : #ASDPORHomePage,
	#superclass : #ASDPORPageLogin,
	#instVars : [
		'centerComponent',
		'loginComponent',
		'showLoginError'
	],
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

{ #category : #accessing }
ASDPORHomePage >> centerComponent [
	^ centerComponent
]

{ #category : #accessing }
ASDPORHomePage >> centerComponent: anObject [
	centerComponent := anObject
]

{ #category : #accessing }
ASDPORHomePage >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #initialize }
ASDPORHomePage >> initialize [
	super initialize.

	
]

{ #category : #accessing }
ASDPORHomePage >> loginComponent [
	^ loginComponent
]

{ #category : #accessing }
ASDPORHomePage >> loginComponent: anObject [
	loginComponent := anObject
]

{ #category : #actions }
ASDPORHomePage >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORHomePage >> rendeModalLoginButtonOn: html [
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
ASDPORHomePage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]

{ #category : #rendering }
ASDPORHomePage >> renderLoginErrorMessageIfAnyOn: html [
	self hasLoginError ifTrue: [
		showLoginError := false.
		html tbsAlert
			beDanger ;
			with: self loginErrorMessage ]
]
