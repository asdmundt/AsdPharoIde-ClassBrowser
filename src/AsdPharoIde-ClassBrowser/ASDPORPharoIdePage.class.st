Class {
	#name : #ASDPORPharoIdePage,
	#superclass : #ASDPORPageModules,
	#instVars : [
		'classBrowser'
	],
	#category : #'AsdPharoIde-ClassBrowser-Web'
}

{ #category : #accessing }
ASDPORPharoIdePage class >> pageName [
	^ 'PharoSmalltalk IDE'
]

{ #category : #accessing }
ASDPORPharoIdePage class >> priority [
	^ 2
]

{ #category : #hooks }
ASDPORPharoIdePage >> children [

	^ { self classBrowser }
]

{ #category : #accessing }
ASDPORPharoIdePage >> classBrowser [
	^ classBrowser
]

{ #category : #initialize }
ASDPORPharoIdePage >> initialize [
	super initialize.
	self session rootComponent header: ASDBPORHeaderPharoIde new.
	classBrowser := ASDPOClassBrowser new.
]

{ #category : #rendering }
ASDPORPharoIdePage >> renderContentOn: html [

	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ 
			html mdlCell
				stretch;
				size: 12;
				with: [ 
					"self renderWindowOn: html
							withComponent: self classBrowser
							andId: self session rootComponent idDialog"
							html render: self classBrowser 
					]
			]
]

{ #category : #rendering }
ASDPORPharoIdePage >> renderWindowOn: html withComponent: aComponent andId: anId [
	html div
		id: anId;
		script:
			(html jQuery new dialog
				title: 'ClassBrowser';
				autoOpen: false;
				html: aComponent;
				addButton: 'Close' do: html jQuery new dialog close).
]
