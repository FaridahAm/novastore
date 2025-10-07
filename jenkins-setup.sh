#!/bin/bash
# Jenkins Job Configuration Script for NovaStore
# This script helps set up the Jenkins pipeline job

echo "🚀 NovaStore Jenkins Job Setup Script"
echo "====================================="

# Configuration variables
JOB_NAME="novastore"
REPO_URL="https://github.com/FaridahAm/novastore.git"
BRANCH="*/main"
SCRIPT_PATH="Jenkinsfile"

echo "📋 Job Configuration:"
echo "   Name: $JOB_NAME"
echo "   Repository: $REPO_URL"
echo "   Branch: $BRANCH"
echo "   Pipeline Script: $SCRIPT_PATH"
echo ""

# Check if Jenkins CLI is available
if command -v jenkins-cli.jar &> /dev/null; then
    echo "✅ Jenkins CLI found"
    
    # Create the pipeline job
    echo "🔧 Creating Jenkins pipeline job..."
    
    cat <<EOF > job-config.xml
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.40">
  <actions/>
  <description>NovaStore React E-commerce Application - CI/CD Pipeline</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.plugins.buildblocker.BuildBlockerProperty plugin="build-blocker-plugin@1.7.3">
      <useBuildBlocker>false</useBuildBlocker>
      <blockLevel>GLOBAL</blockLevel>
      <scanQueueFor>DISABLED</scanQueueFor>
      <blockingJobs></blockingJobs>
    </hudson.plugins.buildblocker.BuildBlockerProperty>
    <com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.29.4">
      <projectUrl>$REPO_URL</projectUrl>
      <displayName></displayName>
    </com.coravy.hudson.plugins.github.GithubProjectProperty>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers>
        <com.cloudbees.jenkins.GitHubPushTrigger plugin="github@1.29.4">
          <spec></spec>
        </com.cloudbees.jenkins.GitHubPushTrigger>
      </triggers>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.80">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.4.5">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>$REPO_URL</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>$BRANCH</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>$SCRIPT_PATH</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

    # Create the job using Jenkins CLI
    java -jar jenkins-cli.jar -s $JENKINS_URL create-job $JOB_NAME < job-config.xml
    
    if [ $? -eq 0 ]; then
        echo "✅ Jenkins job '$JOB_NAME' created successfully!"
    else
        echo "❌ Failed to create Jenkins job"
    fi
    
    # Clean up
    rm job-config.xml
    
else
    echo "⚠️ Jenkins CLI not found. Manual setup required:"
    echo ""
    echo "📋 Manual Setup Instructions:"
    echo "1. Open Jenkins Dashboard"
    echo "2. Click 'New Item'"
    echo "3. Enter name: $JOB_NAME"
    echo "4. Select 'Pipeline' and click OK"
    echo "5. In configuration:"
    echo "   - Description: NovaStore React E-commerce Application"
    echo "   - Pipeline Definition: Pipeline script from SCM"
    echo "   - SCM: Git"
    echo "   - Repository URL: $REPO_URL"
    echo "   - Branch Specifier: $BRANCH"
    echo "   - Script Path: $SCRIPT_PATH"
    echo "6. Save the configuration"
    echo "7. Click 'Build Now' to test"
fi

echo ""
echo "🔧 Additional Setup (Optional):"
echo "   - Configure GitHub webhooks for automatic builds"
echo "   - Set up email notifications"
echo "   - Configure build triggers"
echo "   - Set up build artifacts cleanup"

echo ""
echo "🎉 Setup complete! Your NovaStore pipeline is ready to build."