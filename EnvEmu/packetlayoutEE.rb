#####
# This file is auto generated using ./parser.rb ****
# on 2012-07-18T11:16:50+02:00
#####

Msgt = Array[
    [ 'msgt_preamble', 'uint8_t', 0x00 ],
    [ 'msgt_dst', 'nx_uint16_t', 0xFFFF ],
    [ 'msgt_src', 'nx_uint16_t', 0x0000 ],
    [ 'msgt_len', 'uint8_t' ],
    [ 'msgt_group' , 'uint8_t', 0x00 ],
    [ 'msgt_am' , 'uint8_t', 0xCC ],
]

Msgid_offset = 7
Msgid_datatype = 'uint8_t'


### User packets:

## -------> IN
EEMSGCONFIGSAMPLERa = Array [ 
	 [ "EEMsgConfigSampler_time_us", "nx_uint64_t"], 
	 [ "EEMsgConfigSampler_ADCid", "nx_uint16_t"], 
	 [ "EEMsgConfigSampler_numberOfSamplesReq", "nx_uint16_t"], 
	 [ "EEMsgConfigSampler_sampleRate", "nx_uint16_t"], 
	 [ "EEMsgConfigSampler_triggerLevel", "nx_int16_t"], 
	 [ "EEMsgConfigSampler_samplerReportIDType", "nx_uint16_t"], 
]
EEMSGCONFIGSTREAMERa = Array [ 
	 [ "EEMsgConfigStreamer_time_us", "nx_uint64_t"], 
	 [ "EEMsgConfigStreamer_DACid", "nx_uint16_t"], 
	 [ "EEMsgConfigStreamer_sample", "nxle_uint16_t"], 
	 [ "EEMsgConfigStreamer_outerLoopResistor", "nx_uint16_t"], 
	 [ "EEMsgConfigStreamer_harvester", "nx_int16_t"], 
	 [ "EEMsgConfigStreamer_harvesterCapacitor", "nx_uint32_t"], 
	 [ "EEMsgConfigStreamer_maxDACvalue", "nxle_uint16_t"], 
]
EEMSGSETGPIOPINSTATUSa = Array [ 
	 [ "EEMsgSetGPIOPinStatus_time_us", "nx_uint64_t"], 
	 [ "EEMsgSetGPIOPinStatus_gpioPinStatus", "nx_uint32_t"], ### correct??
]


## <---------- OUT
EEMSGSAMPLERREPORT_NAa = Array [ 
	 [ "EEMsgSamplerReport_NA_ADCid", "nx_uint8_t"], 
	 [ "EEMsgSamplerReport_NA_msgid", "nx_uint8_t"], 
	 [ "EEMsgSamplerReport_NA_min", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_avg", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_max", "nxle_uint16_t"], 

# correct amound of?

	 [ "EEMsgSamplerReport_NA_DACvalue_0", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_1", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_2", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_3", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_4", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_5", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_6", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_7", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_8", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_9", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_10", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_11", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_12", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_13", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_14", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_DACvalue_15", "nxle_uint16_t"], 

# nxle_uint16_t ==> nxle_uint16_t
	 [ "EEMsgSamplerReport_NA_sample_0", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_1", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_2", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_3", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_4", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_5", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_6", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_7", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_8", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_9", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_10", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_11", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_12", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_13", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_14", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_15", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_16", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_17", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_18", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_19", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_20", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_21", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_22", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_23", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_24", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_25", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_26", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_27", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_28", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_29", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_30", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_31", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_32", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_33", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_34", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_35", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_36", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_37", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_38", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_39", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_40", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_41", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_42", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_43", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_44", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_45", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_46", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_47", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_48", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_49", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_50", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_51", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_52", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_53", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_54", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_55", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_56", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_57", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_58", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_59", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_60", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_61", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_62", "nxle_uint16_t"], 
	 [ "EEMsgSamplerReport_NA_sample_63", "nxle_uint16_t"], 
]

EE_MSG_CONFIG_SAMPLER = Msgt + EEMSGCONFIGSAMPLERa 
EE_MSG_CONFIG_STREAMER = Msgt + EEMSGCONFIGSTREAMERa 
EE_MSG_SET_GPIO_PIN_STATUS = Msgt + EEMSGSETGPIOPINSTATUSa 
EE_MSG_SAMPLER_REPORT_NA = Msgt + EEMSGSAMPLERREPORT_NAa


### AM hash:

AM = Hash[
    248 => EE_MSG_CONFIG_SAMPLER,
    250 => EE_MSG_CONFIG_STREAMER,
    252 => EE_MSG_SET_GPIO_PIN_STATUS,
    
    249 => EE_MSG_SAMPLER_REPORT_NA
]

