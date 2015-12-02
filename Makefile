Pods:
	pod install





run: Pods/Starscream/libWebSocket.dylib Pods/Starscream/WebSocket.swiftmodule
	swift -I ./Pods/Starscream -L ./Pods/Starscream -lWebSocket a.swift

build: Pods/Starscream/WebSocket.dylib Pods/Starscream/WebSocket.swiftmodule

Pods/Starscream/libWebSocket.dylib: Pods/Starscream/WebSocket.o Pods/Starscream/SSLSecurity.o
	(cd Pods/Starscream; \
	libtool -macosx_version_min 10.11 \
		-L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx \
	        -lswiftCore \
		-dynamic \
	        -lSystem \
		-install_name @rpath/libWebSocket.dylib \
		-o libWebSocket.dylib \
		WebSocket.o SSLSecurity.o \
		)

Pods/Starscream/WebSocket.o Pods/Starscream/SSLSecurity.o: Pods/Starscream/*.swift 
	(cd Pods/Starscream; \
	swiftc -emit-library \
	       -emit-object \
	       -module-name WebSocket \
	       WebSocket.swift SSLSecurity.swift \
	)

Pods/Starscream/WebSocket.swiftmodule:
	(cd Pods/Starscream; \
	swift -frontend \
	      -emit-module \
	      -module-name WebSocket \
	      -emit-module-path ./WebSocket.swiftmodule \
	      -emit-module-doc-path ./WebSocket.swiftdoc \
	      -sdk "`xcrun --show-sdk-path --sdk macosx`" \
	      *.swift)

clean:
	(cd Pods/Starscream; rm -rf *.o *.dylib *.swiftmodule *.swiftdoc)

