Class {
	#name : #ASDPORPharoIdePage,
	#superclass : #ASDPORPageModules,
	#instVars : [
		'classBrowser',
		'playGround'
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
	self session rootComponent header: ASDBPORHeaderClassBrowser new.
	classBrowser := ASDPOClassBrowser new.
]

{ #category : #accessing }
ASDPORPharoIdePage >> playGround [

	^ playGround
]

{ #category : #accessing }
ASDPORPharoIdePage >> playGround: anObject [

	playGround := anObject
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
				with: [ html div with: [ html render: self classBrowser ] ]
			].
	self renderWindowOn: html
			withComponent: self classBrowser
			andId: self session rootComponent idPlayGrount
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
