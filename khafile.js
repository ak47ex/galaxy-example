let project = new Project('Galaxy');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
project.addLibrary('Pongo');
project.addLibrary('hxrandom');
project.addLibrary('Quadtree');
// project.addDefine('draw_transform');
project.addDefine('fps');

resolve(project);