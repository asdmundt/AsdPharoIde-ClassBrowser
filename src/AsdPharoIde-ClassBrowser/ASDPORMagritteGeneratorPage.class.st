Class {
	#name : #ASDPORMagritteGeneratorPage,
	#superclass : #ASDPORPageLogin,
	#instVars : [
		'centerComponent',
		'loginComponent',
		'showLoginError'
	],
	#category : #'AsdPharoIde-ClassBrowser-Web'
}

{ #category : #accessing }
ASDPORMagritteGeneratorPage class >> pageName [
	^ 'CRUD Genarator'
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage class >> priority [
	^ 3
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage >> centerComponent [
	^ centerComponent
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage >> centerComponent: anObject [
	centerComponent := anObject
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #initialize }
ASDPORMagritteGeneratorPage >> initialize [
	super initialize.

	
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage >> loginComponent [
	^ loginComponent
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage >> loginComponent: anObject [
	loginComponent := anObject
]

{ #category : #actions }
ASDPORMagritteGeneratorPage >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORMagritteGeneratorPage >> rendeModalLoginButtonOn: html [
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
ASDPORMagritteGeneratorPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]

{ #category : #rendering }
ASDPORMagritteGeneratorPage >> renderLoginErrorMessageIfAnyOn: html [
	self hasLoginError ifTrue: [
		showLoginError := false.
		html tbsAlert
			beDanger ;
			with: self loginErrorMessage ]
]
