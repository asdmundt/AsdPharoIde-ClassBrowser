Class {
	#name : #ASDPORProjectManagerPage,
	#superclass : #ASDPORPageLogin,
	#instVars : [
		'centerComponent',
		'loginComponent',
		'showLoginError'
	],
	#category : #'AsdPharoIde-ClassBrowser-Web'
}

{ #category : #accessing }
ASDPORProjectManagerPage class >> pageName [
	^ 'Projektverwaltung'
]

{ #category : #accessing }
ASDPORProjectManagerPage class >> priority [
	^ 2
]

{ #category : #accessing }
ASDPORProjectManagerPage >> centerComponent [
	^ centerComponent
]

{ #category : #accessing }
ASDPORProjectManagerPage >> centerComponent: anObject [
	centerComponent := anObject
]

{ #category : #accessing }
ASDPORProjectManagerPage >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #initialize }
ASDPORProjectManagerPage >> initialize [
	super initialize.

	
]

{ #category : #accessing }
ASDPORProjectManagerPage >> loginComponent [
	^ loginComponent
]

{ #category : #accessing }
ASDPORProjectManagerPage >> loginComponent: anObject [
	loginComponent := anObject
]

{ #category : #actions }
ASDPORProjectManagerPage >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORProjectManagerPage >> rendeModalLoginButtonOn: html [
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
ASDPORProjectManagerPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]

{ #category : #rendering }
ASDPORProjectManagerPage >> renderLoginErrorMessageIfAnyOn: html [
	self hasLoginError ifTrue: [
		showLoginError := false.
		html tbsAlert
			beDanger ;
			with: self loginErrorMessage ]
]
