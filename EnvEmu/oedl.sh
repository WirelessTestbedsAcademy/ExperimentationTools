#!/bin/sh

echo "0 0 0" > plot.dat 
gnuplot -p liveplot.gnu &

echo "Sending config"
echo "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=0, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=0,  EEMsgConfigSampler_samplerReportIDType=0}" | ./write_to_ee.rb
sleep 1
echo "streamer off"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=0, EEMsgConfigStreamer_harvesterCapacitor=0, EEMsgConfigStreamer_harvester=0, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

sleep 3
echo "disable USB"
echo "EE_MSG_SET_GPIO_PIN_STATUS{msgt_am=252, EEMsgSetGPIOPinStatus_time_us=0, EEMsgSetGPIOPinStatus_gpioPinStatus=0x18000000}" | ./write_to_ee.rb

sleep 3
echo "streamer start"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=3550, EEMsgConfigStreamer_harvesterCapacitor=500000, EEMsgConfigStreamer_harvester=0, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

sleep 3
echo "sampler"
echo "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=2000, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=64001,  EEMsgConfigSampler_samplerReportIDType=1}" | ./write_to_ee.rb

sleep 10
echo "streamer update"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=0, EEMsgConfigStreamer_harvesterCapacitor=500000, EEMsgConfigStreamer_harvester=10, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

echo "Sent, waiting for 10s"
sleep 20
echo "stop sampler"
echo "EE_MSG_CONFIG_SAMPLER{msgt_am=248, EEMsgConfigSampler_time_us=0, EEMsgConfigSampler_ADCid=4, EEMsgConfigSampler_sampleRate=2000, EEMsgConfigSampler_triggerLevel=0, EEMsgConfigSampler_numberOfSamplesReq=0,  EEMsgConfigSampler_samplerReportIDType=1}" | ./write_to_ee.rb
sleep 1
echo "streamer off"
echo "EE_MSG_CONFIG_STREAMER{msgt_am=250, EEMsgConfigStreamer_time_us=0, EEMsgConfigStreamer_DACid=1, EEMsgConfigStreamer_sample=0, EEMsgConfigStreamer_harvesterCapacitor=0, EEMsgConfigStreamer_harvester=0, EEMsgConfigStreamer_outerLoopResistor=0, EEMsgConfigStreamer_maxDACvalue = 4095 }" | ./write_to_ee.rb

sleep 3
echo "enable USB"
echo "EE_MSG_SET_GPIO_PIN_STATUS{msgt_am=252, EEMsgSetGPIOPinStatus_time_us=0, EEMsgSetGPIOPinStatus_gpioPinStatus=0x00001800}"  | ./write_to_ee.rb

killall gnuplot