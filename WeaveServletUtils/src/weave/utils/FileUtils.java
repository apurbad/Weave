/*
    Weave (Web-based Analysis and Visualization Environment)
    Copyright (C) 2008-2011 University of Massachusetts Lowell

    This file is a part of Weave.

    Weave is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License, Version 3,
    as published by the Free Software Foundation.

    Weave is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Weave.  If not, see <http://www.gnu.org/licenses/>.
*/

package weave.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

/**
 * @author adufilie
 */
public class FileUtils
{
	public static void copy(String source, String destination) throws IOException
	{
		copy(new File(source), new File(destination));
	}
	public static void copy(File source, File destination) throws IOException
	{
		InputStream in = new FileInputStream(source);
		OutputStream out = new FileOutputStream(destination);
		copy(in, out);
	}
	public static void copy(InputStream in, OutputStream out) throws IOException
	{
		byte[] buffer = new byte[4096];
		int length;
		while ((length = in.read(buffer)) > 0)
			out.write(buffer, 0, length);
		in.close();
		out.close();
	}
	public static void copyFileFromURL(String url, String destination)
	{
		try{
			URL l = new URL(url);
			URLConnection c = l.openConnection();
			c.connect();

			InputStream in = c.getInputStream();

			FileOutputStream out =new FileOutputStream(destination);

			copy(in, out);

		}catch(Exception e)
		{
			System.out.println("Error copying file from URL: " + url);
		}
	}
}