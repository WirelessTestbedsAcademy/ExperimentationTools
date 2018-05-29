#!/bin/sh

duration=3
if [ ! -z $1 ]; then
	duration=$1
fi
	

killall -9 gnuplot_qt
killall -9 gnuplot

echo "0 0 0" > plot.dat 
gnuplot -p liveplot.gnu &



echo "Sending config to terminate any running sampler"
echo "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=0, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=0,  EEMsgConfigSampler_samplerReportIDType=0}" | ./write_to_ee.rb
sleep 0.2
echo "streamer off"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=0, EEMsgConfigStreamer_harvesterCapacitor=0, EEMsgConfigStreamer_harvester=0, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

sleep 0.2
echo "disable USB"
echo "EE_MSG_SET_GPIO_PIN_STATUS{msgt_am=252, EEMsgSetGPIOPinStatus_time_us=0, EEMsgSetGPIOPinStatus_gpioPinStatus=0x18000000}" | ./write_to_ee.rb

sleep 0.2
echo "streamer start"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=4000, EEMsgConfigStreamer_harvesterCapacitor=0, EEMsgConfigStreamer_harvester=0, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

sleep 1
echo "sampler"
echo "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=6000, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=64001,  EEMsgConfigSampler_samplerReportIDType=1}" | ./write_to_ee.rb


echo "waiting for $duration's'"
sleep $duration
echo "stop sampler"
echo "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=6000, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=0,  EEMsgConfigSampler_samplerReportIDType=1}" | ./write_to_ee.rb

sleep 0.2
echo "streamer off"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=0, EEMsgConfigStreamer_harvesterCapacitor=0, EEMsgConfigStreamer_harvester=0, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

sleep 0.2
echo "enable USB"
echo "EE_MSG_SET_GPIO_PIN_STATUS{msgt_am=252, EEMsgSetGPIOPinStatus_time_us=0, EEMsgSetGPIOPinStatus_gpioPinStatus=0x00001800}"  | ./write_to_ee.rb

