module Paperclip
  class Html < Processor
    def make
      case file.content_type
      when 'application/pdf' then convert_from_pdf
      when 'application/msword' then email_admins_to_convert_doc
      when 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' then convert_from_word
      when 'text/rtf' then convert_from_rtf
      when 'text/html' then
        File.new(file.path)
      else
        raise 'invalid type'
      end
    end

  private

    def convert_from_pdf
      # just shell out the command
      `pdf2htmlEX #{file.path}`

      outfile = "#{Rails.root}/#{File.basename(file.path).sub('.pdf', '.html')}"
      File.open(outfile)
    end

    def convert_from_word
      tempfile = Tempfile.new('new_doc')

      html = Docx::Document.open(file.path).to_html
      tempfile.write(html)
      tempfile.rewind

      tempfile
    end

    def convert_from_rtf
      tempfile = Tempfile.new('new_rtf')

      html = Mapi::RTF::Converter.rtf2text(file.read, :html)
      tempfile.write(html)
      tempfile.rewind

      tempfile
    end

    def email_admins_to_convert_doc
      Pony.mail(:to => 'wootie@polymathic.me', :from => 'wootie@polymathic.me', :subject => 'A new word doc needs to get converted.', :body => 'Hooray. The file is <here>.')
    end
  end
end
