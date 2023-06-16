Class {
	#name : #ASDPORCrudGeneratorPage,
	#superclass : #ASDPORPageLogin,
	#instVars : [
		'centerComponent',
		'loginComponent',
		'showLoginError'
	],
	#category : #'AsdPharoIde-ClassBrowser-Web'
}

{ #category : #accessing }
ASDPORCrudGeneratorPage class >> pageName [
	^ 'CRUD Genarator'
]

{ #category : #accessing }
ASDPORCrudGeneratorPage class >> priority [
	^ 3
]

{ #category : #accessing }
ASDPORCrudGeneratorPage >> centerComponent [
	^ centerComponent
]

{ #category : #accessing }
ASDPORCrudGeneratorPage >> centerComponent: anObject [
	centerComponent := anObject
]

{ #category : #accessing }
ASDPORCrudGeneratorPage >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #initialize }
ASDPORCrudGeneratorPage >> initialize [
	super initialize.

	
]

{ #category : #accessing }
ASDPORCrudGeneratorPage >> loginComponent [
	^ loginComponent
]

{ #category : #accessing }
ASDPORCrudGeneratorPage >> loginComponent: anObject [
	loginComponent := anObject
]

{ #category : #actions }
ASDPORCrudGeneratorPage >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORCrudGeneratorPage >> rendeModalLoginButtonOn: html [
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
ASDPORCrudGeneratorPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [ self rendeModalLoginButtonOn: html ] ]
]

{ #category : #rendering }
ASDPORCrudGeneratorPage >> renderLoginErrorMessageIfAnyOn: html [
	self hasLoginError ifTrue: [
		showLoginError := false.
		html tbsAlert
			beDanger ;
			with: self loginErrorMessage ]
]
