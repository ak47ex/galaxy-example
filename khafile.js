let project = new Project('Galaxy');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
project.addLibrary('Pongo');
project.addLibrary('hxrandom');
// project.addDefine('draw_transform');

resolve(project);