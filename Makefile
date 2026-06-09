.PHONY: content doe-starter regional-sprint fls xcode verify build

content: doe-starter regional-sprint fls verify xcode
	@echo "Content pipeline complete."

doe-starter:
	python3 Scripts/build_doe_starter_cache.py

regional-sprint:
	python3 Scripts/build_regional_sprint.py

fls:
	python3 Scripts/build_fls_catalog.py

verify:
	python3 Scripts/verify_topic_readings.py
	python3 Scripts/verify_question_coverage.py

xcode:
	python3 Scripts/generate_xcode_project.py

build:
	python3 Scripts/generate_xcode_project.py
	xcodebuild -project ScienceBowlCoach.xcodeproj -scheme ScienceBowlCoach -destination 'platform=macOS' -configuration Debug build
