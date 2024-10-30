Class {
	#name : #ASDPORProjectManagerPage,
	#superclass : #ASDPORPageModules,
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

{ #category : #initialize }
ASDPORProjectManagerPage >> initialize [
	super initialize.

	
]

{ #category : #rendering }
ASDPORProjectManagerPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [  ] ]
]
