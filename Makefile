.PHONY: content doe-starter regional-sprint xcode verify build

content: doe-starter regional-sprint verify xcode
	@echo "Content pipeline complete."

doe-starter:
	python3 Scripts/build_doe_starter_cache.py

regional-sprint:
	python3 Scripts/build_regional_sprint.py

verify:
	python3 Scripts/verify_topic_readings.py

xcode:
	python3 Scripts/generate_xcode_project.py

build:
	python3 Scripts/generate_xcode_project.py
	xcodebuild -project ScienceBowlCoach.xcodeproj -scheme ScienceBowlCoach -destination 'platform=macOS' -configuration Debug build
