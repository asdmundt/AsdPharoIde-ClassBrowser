Class {
	#name : #ASDPORRootComponent,
	#superclass : #ASDPORComponent,
	#traits : 'TRootDialogRenderer',
	#classTraits : 'TRootDialogRenderer classTrait',
	#instVars : [
		'header',
		'componentToDisplay',
		'componentInstances',
		'footer',
		'showLoginError',
		'rightPanel'
	],
	#category : #'AsdPharoIde-ClassBrowser-Core'
}

{ #category : #testing }
ASDPORRootComponent class >> canBeRoot [
	^ true
]

{ #category : #versions }
ASDPORRootComponent class >> development [
	^ true
]

{ #category : #initialization }
ASDPORRootComponent class >> initialize [
	self environment
		at: #WADevelopmentConfiguration
		ifPresent: [ :class | WAAdmin applicationDefaults addParent: class instance ].	"Remove development tools."
	^ (WAAdmin register: self asApplicationAt: 'asdclassbrowser')
		preferenceAt: #sessionClass put: ASDPORPSession;
		addLibrary: JQDeploymentLibrary;
		addLibrary: JQUiDeploymentLibrary;
		addLibrary: MDLLibrary;
		addLibrary: ASDPORLibrary;
		"preferenceAt: #sessionClass put: ASDPORPSession;"
			yourself
]

{ #category : #testing }
ASDPORRootComponent class >> isRpi [
^ true
]

{ #category : #versions }
ASDPORRootComponent class >> version [
	^ '0.0.04'
]

{ #category : #hooks }
ASDPORRootComponent >> children [

	^ { 
		  self header.
		  self componentToDisplay.
		  self rightPanel.
		  self footer }
]

{ #category : #accessing }
ASDPORRootComponent >> componentInstances [
	"I return a dictionary with browsers as keys and their instances as value if they were instantiated at least once."

	^ componentInstances
]

{ #category : #accessing }
ASDPORRootComponent >> componentInstances: aDictionary [
	componentInstances := aDictionary
]

{ #category : #accessing }
ASDPORRootComponent >> componentToDisplay [
	"Component instance to display in the application."
	
	^ componentToDisplay
]

{ #category : #accessing }
ASDPORRootComponent >> componentToDisplay: aComponent [
	componentToDisplay := aComponent
]

{ #category : #components }
ASDPORRootComponent >> defaultFooter [
	^ ASDSFooter new
]

{ #category : #components }
ASDPORRootComponent >> defaultHeader [
	^ ASDSHeader new
]

{ #category : #updating }
ASDPORRootComponent >> displayInstanceOf: aComponentClass [
	self session resetStates.
	"self componentToDisplay: (self componentInstances at: aComponentClass ifAbsentPut: [ aComponentClass new ])"
	self componentToDisplay: (self componentInstances at: aComponentClass ifPresent:[aComponentClass new] ifAbsentPut: [ aComponentClass new ])
]

{ #category : #updating }
ASDPORRootComponent >> displayInstanceOfWithSessionState: aComponentClass [
	"self componentToDisplay: (self componentInstances at: aComponentClass ifAbsentPut: [ aComponentClass new ])"
	self componentToDisplay: (self componentInstances at: aComponentClass ifPresent:[ aComponentClass new ] ifAbsentPut: [  aComponentClass new ])
]

{ #category : #updating }
ASDPORRootComponent >> displayInstanceOfWithSessionStateAndAdd: aComponentClass [
	"self componentToDisplay: (self componentInstances at: aComponentClass ifAbsentPut: [ aComponentClass new ])"

	self componentToDisplay: (self componentInstances at: aComponentClass ifPresent: [ (aComponentClass new) addSelf ] ifAbsentPut: [ (aComponentClass new) addSelf ])
]

{ #category : #accessing }
ASDPORRootComponent >> footer [
	^ footer
]

{ #category : #accessing }
ASDPORRootComponent >> footer: aComponent [
	footer := aComponent
]

{ #category : #actions }
ASDPORRootComponent >> goToAdminView [
	self displayInstanceOf: ASDSAdminHomeControlPage 
]

{ #category : #actions }
ASDPORRootComponent >> goToInstallView [
	self displayInstanceOf: ASDSZentraleInstallerPage 
]

{ #category : #actions }
ASDPORRootComponent >> goToLoginView [
	self displayInstanceOf: ASDSLoginPage
]

{ #category : #actions }
ASDPORRootComponent >> goToOverviewView [
	self displayInstanceOf: ASDSOverviewPage
]

{ #category : #accessing }
ASDPORRootComponent >> hasLoginError [
	^ showLoginError ifNil: [ false ]
]

{ #category : #accessing }
ASDPORRootComponent >> header [
	^ header
]

{ #category : #accessing }
ASDPORRootComponent >> header: aComponent [
	header := aComponent
]

{ #category : #hooks }
ASDPORRootComponent >> initialRequest: aRequest [
	| consumer pageName |
	super initialRequest: aRequest.
	consumer := self requestContext consumer.
	
	"If we are at end, nothing to manage"
	consumer atEnd
		ifTrue: [ ^ self ].
	pageName := consumer peek asLowercase.	"Do not make URLs case sensitive in that case"

	"Try to find a page corresponding"
	self header possiblePages
		detect: [ :each | each pathName asLowercase = pageName ]
		ifFound: [ :class | 
			self displayInstanceOf: class.

			"If we find a page, we pop the subpart of the path corresponding to the page."
			consumer next ]
]

{ #category : #initialization }
ASDPORRootComponent >> initialize [
	super initialize.
	self header: self defaultHeader.
	self footer: self defaultFooter.
	self session rootComponent: self.
	self rightPanel: ASDComponentWithRightPanel new.
	self session os: (SmalltalkImage current vm getSystemAttribute: 1001).
	self componentInstances: Dictionary new.
	self displayInstanceOf: self header possiblePages first
]

{ #category : #actions }
ASDPORRootComponent >> loginErrorOccured [
        showLoginError := true
]

{ #category : #rendering }
ASDPORRootComponent >> renderContentOn: html [

	html mdlLayout
		fixedHeader;
		with: [ 
			html render: self header.
			html mdlLayoutContent
				class: 'mdl-color-text--grey-600';
				with: [ 
					html mdlGrid
						noSpacing;
						with: [ "noSpacing;""html render: self footer"
							html mdlCell
								class: 'rootComponent';
								size: 12;
								stretch;
								with: [ 
									html div
										id: #main;
										with: [ html render: self componentToDisplay ].
									html render: self rightPanel ] ] ] ].
	self renderEmptyGenericDialogOn: html
]

{ #category : #rendering }
ASDPORRootComponent >> renderRightPanel: html [
html div
										shadow: 0;
										style: 'height: 700px; display: flex;';
										with: ASDSComponentWithRightPanel new
	
]

{ #category : #accessing }
ASDPORRootComponent >> rightPanel [
	^ rightPanel
]

{ #category : #accessing }
ASDPORRootComponent >> rightPanel: anObject [
	rightPanel := anObject
]

{ #category : #hooks }
ASDPORRootComponent >> states [
    ^ Array with: self
]

{ #category : #actions }
ASDPORRootComponent >> tryConnectionWithLogin: login andPassword: password [
	| user |
	user := self session model userFromLogin: login andPassword: password.
	"self halt."
	user
		ifNotNil: [ :arg | 
			self session currentUser: arg.

			"arg logged: true."
			self session model addLoggedUser: arg.
			self session first: true.
			arg isAdmin
				ifTrue: [ arg isInstallReady
						ifTrue: [ self goToAdminView ]
						ifFalse: [ self  goToInstallView ] ]
				ifFalse: [ self goToOverviewView ] ]
		ifNil: [ self session loginError.
			self goToLoginView ]
]

{ #category : #updating }
ASDPORRootComponent >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	anHtmlRoot beHtml5.
	anHtmlRoot title: 'ASDMundtSmartHomeVerwaltung'.
	anHtmlRoot meta
		attributeAt: 'name' put: 'viewport';
		content: 'width=device-width, initial-scale=1'.
	"self updateTabIconRoot: anHtmlRoot."
	"anHtmlRoot stylesheet url: (WAUrl absolute: 'https://code.getmdl.io/1.3.0/material.blue_grey-blue.min.css').
	anHtmlRoot javascript add: 'hljs.initHighlightingOnLoad();'."
	anHtmlRoot stylesheet url: 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/themes/' , 'base' , '/jquery-ui.css'
]

{ #category : #updating }
ASDPORRootComponent >> updateUrl: aUrl [
	super updateUrl: aUrl.
	aUrl addToPath: (self componentToDisplay pathName)
]