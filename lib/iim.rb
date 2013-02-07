module Iim
  def timecode_format(timecode)
    t = timecode.split(/:/)
    tc = convert_to_two_digits(t[0].to_i) + ":" + convert_to_two_digits(t[1].to_i) + ":" + convert_to_two_digits(t[2].to_i) + ":"  + convert_to_two_digits(t[3].to_i)
  end
  
  def timecode_duration(time_in, time_out, fps)
    convert_frames_to_timecode(convert_timecode_to_frames(time_out,fps) - convert_timecode_to_frames(time_in,fps), fps)
  end
    
  def convert_timecode_to_frames(timecode, fps)
      tc = timecode.split(":")
      frames = (tc[0].to_i * 60 * 60 * fps) + (tc[1].to_i * 60 * fps) + (tc[2].to_i * fps) + tc[3].to_i
  end

  def convert_frames_to_timecode(frames, fps)
    hh = frames / (60*60*fps)
    mm = (frames - (hh*60*60*fps)) / (60*fps)
    ss = (frames - (hh*60*60*fps) - (mm*60*fps)) / fps
    ff = (frames - (hh*60*60*fps) - (mm*60*fps) - (ss*fps)) 
    timecode = convert_to_two_digits(hh).to_s + ":" + convert_to_two_digits(mm).to_s + ":" + convert_to_two_digits(ss).to_s + ":" + convert_to_two_digits(ff).to_s
  end
  
  def convert_to_two_digits(x)
    if  x < 10  then   x = "0#{x}"
	  end 
	  x.to_s
  end
  
  # hh:mm:ss
  def convert_timecode_to_seconds(timecode)
      tc = timecode.split(":")
      frames = (tc[0].to_i * 60 * 60) + (tc[1].to_i * 60) + (tc[2].to_i)
  end

  # hh:mm:ss
  def convert_seconds_to_timecode(seconds)
    hh = seconds / (60*60)
    mm = (seconds - (hh*60*60)) / (60)
    ss = (seconds - (hh*60*60) - (mm*60))
    timecode = convert_to_two_digits(hh).to_s + ":" + convert_to_two_digits(mm).to_s + ":" + convert_to_two_digits(ss).to_s 
  end
  
end