pipeline {
    agent { label 'windows-vm' }
    stages {
        stage('Setup') {
            steps {
                checkout scm
                //bat "mkdir ${env.WORKSPACE}\\build"
                bat "mkdir build"
                dir("build")
                {
                  bat 'git clone --branch v0.3.5 --depth 1 https://github.com/google/glog'
                  dir("glog")
                  {
                      bat 'mkdir build_0_3_5'
                      dir("build_0_3_5")
                      {
                          bat 'cmake -DWITH_GFLAGS=off -DCMAKE_INSTALL_PREFIX="${env.WORKSPACE}\\..\\..\\..\\build\\glog" -G "Visual Studio 15 2017 Win64" ..'
                          bat 'cmake --build . --target install --config Debug'
                          bat 'cmake --build . --target install --config Release'
                      }
                  }
                  bat 'git clone --branch v3.1-stable --depth 1 https://github.com/warmcat/libwebsockets'
                  dir("libwebsockets")
                  {
                      bat 'mkdir build_3_1'
                      dir("build_3_1")
                      {
                          bat 'cmake -DOPENSSL_ROOT_DIR="C:/Program Files/OpenSSL-Win64" -DCMAKE_INSTALL_PREFIX="${env.WORKSPACE}\\..\\..\\..\\build\\websockets" -G "Visual Studio 15 2017 Win64" ..'
                          bat 'cmake --build . --target install --config Debug'
                          bat 'cmake --build . --target install --config Release'
                      }
                  }
                  bat 'git clone --branch v3.9.0 --depth 1 https://github.com/protocolbuffers/protobuf'
                  dir("protobuf")
                  {
                      bat "mkdir build_3_9_0"
                      dir("build_3_9_0")
                      {
                          bat 'cmake -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_MSVC_STATIC_RUNTIME=OFF -DCMAKE_INSTALL_PREFIX="${env.WORKSPACE}\\..\\..\\..\\build\\protobuf" -G "Visual Studio 15 2017 Win64" ../cmake'
                          bat 'cmake --build . --target install --config Debug'
                          bat 'cmake --build . --target install --config Release'

                      }

                  }
                  bat 'git clone https://github.com/analogdevicesinc/aditof_sdk.git'
                  dir('aditof_sdk')
                  {
                      bat 'mkdir build'
                      dir('build')
                      {
                          //bat 'cmake -DCMAKE_PREFIX_PATH="C:/projects/aditof-sdk/build/glog/build_0_3_5/local_path/glog;C:/projects/aditof-sdk/build/protobuf\build_3_9_0/local_path/protobuf;C:/projects/aditof-sdk/build/libwebsockets/build_3_1/local_path/websockets" -G "Visual Studio 15 2017 Win64" -DOPENSSL_INCLUDE_DIRS="C:/Program Files/OpenSSL-Win64/include" -DWITH_EXAMPLES=off ..'
                          bat 'cmake -DWITH_EXAMPLES=off -DWITH_MATLAB=on -DMatlab_ROOT_DIR="C:/Program Files/MATLAB/R2019b" -DCMAKE_PREFIX_PATH="${env.WORKSPACE}\\..\\..\\..\\build\\glog;${env.WORKSPACE}\\..\\..\\..\\build\\protobuf;${env.WORKSPACE}\\..\\..\\..\\build\\websockets" -G "Visual Studio 15 2017 Win64" -DOPENSSL_INCLUDE_DIRS="C:/Program Files/OpenSSL-Win64/include" ..'
                          bat 'cmake --build . --config Release'
                      }
                  }
                }
            }
        }
        stage('Test') {
            steps {
                bat 'dir'
            }
        }
        stage('Package') {
            steps {
                dir "mkdir deps"
                dir("build")
                {
                  bat 'dir aditof_sdk\\build\\'
                  bat 'copy aditof_sdk\\build\\sdk\\Release\\aditof.dll ..\\deps\\'
                  bat 'copy "C:\\Program Files\\OpenSSL-Win64\\*.dll" ..\\deps\\'
                  bat 'copy aditof_sdk\\build\\bindings\\matlab\\Release\\aditofadapter.dll ..\\deps\\'
                }
                // bat 'copy C:\\Program Files\\OpenSSL-Win64\\bin\\libeay32.dll package\\'
                // bat 'copy C:\\Program Files\\OpenSSL-Win64\\bin\\ssleay32.dll package\\'
                archiveArtifacts 'deps\\*'
            }
        }
    }
    post { cleanup { cleanWs() } }
}
