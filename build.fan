#! /usr/bin/env fan

// Developed by the National Renewable Energy Laboratory
// NREL internal use only (at this time)

using build

**
** Build: nrelPredictiveAnalyticsExt
**

class Build : BuildPod
{
  new make()
  {
    podName = "nrelPredictiveAnalyticsExt"
    summary = "Interface extension for NREL predictive analytics tools"
    version = Version("0.1")
    meta    = [
                "ext.name":        "nrelPredictiveAnalytics", // TO DO: Update
                "ext.icon":        "target",
                "ext.depends":     "docker,py",
                "org.name":        "NREL",
                "org.uri":         "https://www.nrel.gov/",
                "proj.name":       "NREL Predictive Analytics Extension", // TO DO: Update
                "proj.uri":        "https://github.com/NREL/intelligentcampus-model-deploy", // TO DO: Update
                "license.name":    "Commercial", // TO DO: Update
              ]
    depends = ["sys 1.0"]
    resDirs = [`lib/`, `locale/`]
    index   = ["skyarc.ext": "nrelPredictiveAnalyticsExt"]
  }
  
  // FUTURE USE: Stackhub Publishing
  
  // To publish to StackHub, use: bin/fan /path/to/build.fan publish 
  // For more information, see: https://skyfoundry.com/doc/stackhub/index#publishing
  
  //@Target { help = "Publish to stackhub.org " }
  //Void publish() { stackhub::PublishTask(this).run }
}
