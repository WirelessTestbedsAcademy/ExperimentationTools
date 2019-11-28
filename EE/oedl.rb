# OMF APPLICATION DEFINITION FOR SF-wrapper
# author: vsercu@intec.ugent.be
 
#- APPDEF for the wrapper ---------------
 
defApplication('eewrapper', 'eewrapper-script') do |app|
   app.path = File.join(File.dirname(__FILE__), 'connectEE.rb')
   app.appPackage = "http://ec.wilab2.ilabt.iminds.be/upload/eestuff.tar"  # appdef has to be in same dir as this tar-file!
 
# some descriptions
   app.version(1, 0, 0)
   app.shortDescription = "Wraps sf for EE."
   app.description = "Wraps a serial forwarder at localhost:9003 (ttyUSB0) and passes the output to the OML-server. 
                      Uses packetlayoutEE.rb to parse the fields."
 
# dummy measurement def
   app.defMeasurement('eemeasure') do |mp|
   end
end
 
# no need for sensornode
#
#defMoteApplication("sfwrapper","App that receives data and toggles a led.") do |app|
#  app.appPackage = "packetlayout.tar"
#  app.gatewayExecutable = "ruby connectsf.rb"
#  app.moteExecutable = "main.exe"
#  app.moteType = "rm090"
#  app.moteOS = "TinyOS 2.1.1"

  # a dummy measurement definition
#  app.defMeasurement('sfmeasure') do |mp|
#  end
#end

defApplication("eewrite","eewriting prog, same as sfwrite but with another port") do |app|
   app.path = File.join(File.dirname(__FILE__), 'write_to_ee.rb')
end




## OEDL
defGroup('g1', "node0.baselineomf.testbed.wilab2.ilabt.iminds.be") {|node|
  node.addApplication("eewrapper") do |app|
    app.measure('eemeasure') # must measure something else no EXPID/NODEID etc is passed
  end

  node.addApplication("eewrite", {:id => 'sfwrite_EE'}) {|app| }
}
 
onEvent(:ALL_UP_AND_INSTALLED) do |event|

  # ONLY HAVE TO DO THIS ONCE to program the EE
  #group('g1').exec('killall sf')
  #group('g1').exec('tos-bsl --telos -c /dev/ee -r -e -I -p main.ihex')
  #wait 60

  allGroups.startApplications


 
  wait 7
  info "Sending config"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=0, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=0,  EEMsgConfigSampler_samplerReportIDType=0}" )
  sleep 3

  info "disable USB"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_SET_GPIO_PIN_STATUS{msgt_am=252, EEMsgSetGPIOPinStatus_time_us=0, EEMsgSetGPIOPinStatus_gpioPinStatus=0x08000000}")
  sleep 3

  info "streamer"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=3550, EEMsgConfigStreamer_harvesterCapacitor=100000, EEMsgConfigStreamer_harvester=2000, EEMsgConfigStreamer_outerLoopResistor=15, EEMsgConfigStreamer_maxDACvalue = 3810} }")
  sleep 3

  info "sampler"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=2000, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=64001,  EEMsgConfigSampler_samplerReportIDType=1}")

  sleep 3
  info "streamer"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=0, EEMsgConfigStreamer_harvesterCapacitor=100000, EEMsgConfigStreamer_harvester=4000, EEMsgConfigStreamer_outerLoopResistor=15, EEMsgConfigStreamer_maxDACvalue = 3810} }")

  info "Sent, waiting for 100s"
  wait 100

  info "stop sampler"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=2000, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=0,  EEMsgConfigSampler_samplerReportIDType=1}")

  info "enable USB"
  group('g1').sendMessage('sfwrite_EE',
            "EE_MSG_SET_GPIO_PIN_STATUS{msgt_am=252, EEMsgSetGPIOPinStatus_time_us=0, EEMsgSetGPIOPinStatus_gpioPinStatus=0x00000800}" # == enable
  )
 
  allGroups.stopApplications
  Experiment.done
end
