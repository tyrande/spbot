#-*- coding:utf-8 -*-
import os, re, xml.etree.ElementTree  



if __name__ == "__main__":
    doc = xml.etree.ElementTree.parse("./light-bulb-4.xml")
    # for node in doc.findall("//*"):
    #     print (node, node.tag)
    root = doc.getroot()
    icos = {}
    for node in root.iter("{http://www.w3.org/2000/svg}path"):
        print node.attrib['d']
    
    # for node in root.iter('{http://www.w3.org/2000/svg}g'):
        # if node.attrib.has_key('id'):  
        #     if not re.search("^zzz", node.attrib['id']):
        #         print node.attrib
        #         icos[node.attrib['id']] = {}
        #         for path in node.iter('{http://www.w3.org/2000/svg}path'):
        #             if path.attrib.has_key('d'):
        #                 m = re.match("[Mm]([^A-Za-z]*)[A-Za-z]", path.attrib['d'])
        #                 if m:
        #                     coo = m.group(1).split(',')
        #                     x = int(float(coo[0]))
        #                     y = int(float(coo[1]))
        #                     print (x/60)*30
        #                     print (y/60)*30
        #                     icos[node.attrib['id']]['x'] = (x/60)*30
        #                     icos[node.attrib['id']]['y'] = (y/60)*30
        #                     break
    
    
    