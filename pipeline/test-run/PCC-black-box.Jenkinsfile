stage('Call PrepareEnv') {
        steps {
            script {
		                 build job: 'PrepareEnv', parameters: [
				                                                   string(name: 'deployNode', value: ${deployNode}),
					                                                 string(name: 'release', value: ${release}),
					                                                 string(name: 'registryUrl', value: ${registryUrl}),
				                                                   string(name: 'testToRun', value: ${testToRun}),
					                                                 string(name: 'bbBranch', value: ${bbBranch}),
					                                                 string(name: 'testEnvJson', value: ${testEnvJson}),
					                                                 string(name: 'testToRun', value: ${testToRun}),
					                                                 booleanParam(name: 'softRun', value: ${softRun})
				                                                  ], propagate: false, wait: true
      	  	          }
                 }
}
