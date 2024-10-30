Class {
	#name : #ASDPORLoginPage,
	#superclass : #ASDPORPage,
	#instVars : [
		'centerComponent',
		'loginComponent',
		'showLoginError'
	],
	#category : #'AsdPharoIde-ClassBrowser-Web'
}

{ #category : #accessing }
ASDPORLoginPage class >> pageName [
	^ 'Login'
]

{ #category : #accessing }
ASDPORLoginPage class >> priority [
	^ 1
]

{ #category : #accessing }
ASDPORLoginPage >> centerComponent [
	^ centerComponent
]

{ #category : #accessing }
ASDPORLoginPage >> centerComponent: anObject [
	centerComponent := anObject
]

{ #category : #accessing }
ASDPORLoginPage >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #initialize }
ASDPORLoginPage >> initialize [
	super initialize.

	
]

{ #category : #accessing }
ASDPORLoginPage >> loginComponent [
	^ loginComponent
]

{ #category : #accessing }
ASDPORLoginPage >> loginComponent: anObject [
	loginComponent := anObject
]

{ #category : #actions }
ASDPORLoginPage >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORLoginPage >> rendeModalLoginButtonOn: html [
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
ASDPORLoginPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]
